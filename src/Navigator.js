
import React from 'react';
import PrivateRoutes  from './PrivateRoutes';
import { useAuth } from './context/auth';
import { PublicRoutes } from './PublicRoutes';
// Imports End

export default function Navigator() {
  const { signed } = useAuth();
  return (
    <>
      {signed ? <PrivateRoutes /> : <PublicRoutes />}
    </>
  )
}

