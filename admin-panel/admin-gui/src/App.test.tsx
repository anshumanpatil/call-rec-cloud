import React from 'react';
import { render, screen } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import App from './App';

test('renders login page heading', () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>
  );

  const headingElement = screen.getByRole('heading', { name: /login/i });
  expect(headingElement).toBeInTheDocument();
});
