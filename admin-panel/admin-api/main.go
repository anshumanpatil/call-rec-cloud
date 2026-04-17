package main

import (
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

const (
	hardcodedUsername = "admin"
	hardcodedPassword = "admin123"
	jwtSecret         = "super-secret-key-change-me"
	uploadDir         = "uploads"
)

type loginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type uploadNode struct {
	Name       string       `json:"name"`
	Type       string       `json:"type"`
	Path       string       `json:"path"`
	SizeBytes  int64        `json:"sizeBytes,omitempty"`
	ModifiedAt string       `json:"modifiedAt,omitempty"`
	Children   []uploadNode `json:"children,omitempty"`
}

func main() {
	r := gin.Default()
	r.MaxMultipartMemory = 8 << 20 // 8 MiB
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
		MaxAge:           12 * time.Hour,
	}))

	r.POST("/login", loginHandler)
	r.GET("/dashboard", authMiddleware(), dashboardHandler)
	r.POST("/upload", uploadHandler)

	if err := r.Run(":5656"); err != nil {
		panic(err)
	}
}

func loginHandler(c *gin.Context) {
	var req loginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username and password are required"})
		return
	}

	if req.Username != hardcodedUsername || req.Password != hardcodedPassword {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid username or password"})
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": req.Username,
		"exp": time.Now().Add(24 * time.Hour).Unix(),
	})

	tokenString, err := token.SignedString([]byte(jwtSecret))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}

func dashboardHandler(c *gin.Context) {
	tree, err := buildUploadsTree(uploadDir)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to read uploads folder"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"uploads": tree,
	})
}

func buildUploadsTree(root string) (uploadNode, error) {
	if _, err := os.Stat(root); err != nil {
		if os.IsNotExist(err) {
			return uploadNode{
				Name:     root,
				Type:     "folder",
				Path:     root,
				Children: []uploadNode{},
			}, nil
		}
		return uploadNode{}, err
	}

	return buildUploadNode(root, root)
}

func buildUploadNode(basePath string, currentPath string) (uploadNode, error) {
	info, err := os.Stat(currentPath)
	if err != nil {
		return uploadNode{}, err
	}

	relPath, err := filepath.Rel(basePath, currentPath)
	if err != nil {
		return uploadNode{}, err
	}
	if relPath == "." {
		relPath = filepath.Base(basePath)
	}

	node := uploadNode{
		Name: info.Name(),
		Type: "file",
		Path: filepath.ToSlash(relPath),
	}

	if info.IsDir() {
		node.Type = "folder"
		entries, err := os.ReadDir(currentPath)
		if err != nil {
			return uploadNode{}, err
		}

		node.Children = make([]uploadNode, 0, len(entries))
		for _, entry := range entries {
			childPath := filepath.Join(currentPath, entry.Name())
			child, err := buildUploadNode(basePath, childPath)
			if err != nil {
				return uploadNode{}, err
			}
			node.Children = append(node.Children, child)
		}

		return node, nil
	}

	node.SizeBytes = info.Size()
	node.ModifiedAt = info.ModTime().UTC().Format(time.RFC3339)
	return node, nil
}

func uploadHandler(c *gin.Context) {
	fileHeader, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "file is required (multipart field name: file)"})
		return
	}

	requestedFolder := strings.TrimSpace(c.PostForm("foldername"))
	if requestedFolder == "" {
		requestedFolder = strings.TrimSpace(c.PostForm("folderName"))
	}
	if requestedFolder == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "foldername is required"})
		return
	}

	cleanFolder := filepath.Clean(requestedFolder)
	if cleanFolder == "." || cleanFolder == "/" || filepath.IsAbs(cleanFolder) || strings.HasPrefix(cleanFolder, "..") {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid foldername"})
		return
	}

	targetDir := filepath.Join(uploadDir, cleanFolder)

	if err := os.MkdirAll(targetDir, 0o755); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create upload directory"})
		return
	}

	cleanName := filepath.Base(fileHeader.Filename)
	savedName := time.Now().Format("20060102150405") + "_" + cleanName
	destination := filepath.Join(targetDir, savedName)

	if err := c.SaveUploadedFile(fileHeader, destination); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save file"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "file uploaded successfully",
		"folder":   cleanFolder,
		"filename": savedName,
		"path":     destination,
	})
}

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing authorization header"})
			return
		}

		const prefix = "Bearer "
		if !strings.HasPrefix(authHeader, prefix) {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid authorization header"})
			return
		}

		tokenString := strings.TrimPrefix(authHeader, prefix)
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return []byte(jwtSecret), nil
		}, jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}))
		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
			return
		}

		c.Next()
	}
}
