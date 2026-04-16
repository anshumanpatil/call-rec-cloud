import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

interface DashboardProps {
  onLogout: () => void;
}

interface UploadNode {
  name: string;
  type: 'folder' | 'file';
  path: string;
  sizeBytes?: number;
  modifiedAt?: string;
  children?: UploadNode[];
}

const Dashboard: React.FC<DashboardProps> = ({ onLogout }) => {
  const navigate = useNavigate();
  const [folderName, setFolderName] = useState<string>('');
  const [uploadMessage, setUploadMessage] = useState<string>('');
  const [uploadError, setUploadError] = useState<string>('');
  const [isUploading, setIsUploading] = useState<boolean>(false);
  const [uploadsTree, setUploadsTree] = useState<UploadNode | null>(null);
  const [isTreeLoading, setIsTreeLoading] = useState<boolean>(false);
  const [treeError, setTreeError] = useState<string>('');
  const [collapsedPaths, setCollapsedPaths] = useState<Set<string>>(new Set());

  const handleLogout = () => {
    onLogout();
    navigate('/login');
  };

  const fetchUploadsTree = async () => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      setTreeError('You are not authenticated. Please login again.');
      setUploadsTree(null);
      return;
    }

    setIsTreeLoading(true);
    setTreeError('');

    try {
      const response = await fetch('http://localhost:5656/dashboard', {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      const result = await response.json();
      if (!response.ok) {
        setTreeError(result.error ?? 'Failed to load uploads');
        setUploadsTree(null);
        return;
      }

      setUploadsTree((result.uploads as UploadNode) ?? null);
    } catch {
      setTreeError('Unable to load uploads list from API');
      setUploadsTree(null);
    } finally {
      setIsTreeLoading(false);
    }
  };

  useEffect(() => {
    fetchUploadsTree();
  }, []);

  const uploadFile = async (file: File) => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      setUploadError('You are not authenticated. Please login again.');
      return;
    }

    const formData = new FormData();
    formData.append('file', file);
    if (folderName.trim()) {
      formData.append('foldername', folderName.trim());
    }

    setIsUploading(true);
    setUploadError('');
    setUploadMessage('');

    try {
      const response = await fetch('http://localhost:5656/upload', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: formData,
      });

      const result = await response.json();
      if (!response.ok) {
        setUploadError(result.error ?? 'Upload failed');
        return;
      }

      setUploadMessage(`Uploaded: ${result.filename as string}`);
      fetchUploadsTree();
    } catch {
      setUploadError('Unable to connect to upload API');
    } finally {
      setIsUploading(false);
    }
  };

  const handlePickFile = () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '*/*';
    input.onchange = async () => {
      const file = input.files?.[0];
      if (!file) {
        return;
      }
      await uploadFile(file);
    };
    input.click();
  };

  const renderNode = (node: UploadNode): React.ReactElement => {
    if (node.type === 'file') {
      return (
        <li key={node.path} className="tree-file">
          <span>{node.name}</span>
        </li>
      );
    }

    const isCollapsed = collapsedPaths.has(node.path);

    const handleToggle = () => {
      setCollapsedPaths((prev) => {
        const next = new Set(prev);
        if (next.has(node.path)) {
          next.delete(node.path);
        } else {
          next.add(node.path);
        }
        return next;
      });
    };

    return (
      <li key={node.path} className="tree-folder">
        <button type="button" className="tree-toggle" onClick={handleToggle}>
          {isCollapsed ? '▸' : '▾'} {node.name}
        </button>
        {!isCollapsed && node.children && node.children.length > 0 && (
          <ul className="tree-list">
            {node.children.map((child) => renderNode(child))}
          </ul>
        )}
      </li>
    );
  };

  return (
    <section>
      <h1>Dashboard</h1>
      <p>You are now on the dashboard route.</p>

      <div className="upload-row">
        <label htmlFor="folder-name">Folder Name</label>
        <input
          id="folder-name"
          type="text"
          value={folderName}
          onChange={(event) => setFolderName(event.target.value)}
          placeholder="Enter folder name"
        />
        <button type="button" className="primary-link" onClick={handlePickFile} disabled={isUploading}>
          {isUploading ? 'Uploading...' : 'Upload'}
        </button>
      </div>

      {uploadError && <p className="error-text">{uploadError}</p>}
      {uploadMessage && <p className="success-text">{uploadMessage}</p>}

      <button type="button" className="primary-link" onClick={handleLogout}>
        Logout
      </button>

      <section className="uploads-tree-wrap">
        <h2>Uploaded Files</h2>
        {isTreeLoading && <p>Loading files...</p>}
        {treeError && <p className="error-text">{treeError}</p>}
        {!isTreeLoading && !treeError && uploadsTree && (
          <ul className="tree-list">{renderNode(uploadsTree)}</ul>
        )}
      </section>
    </section>
  );
};

export default Dashboard;
