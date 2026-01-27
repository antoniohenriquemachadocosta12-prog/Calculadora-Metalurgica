import React from 'react';

interface LogoProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  onClick?: () => void;
  className?: string;
}

const sizeMap = {
  sm: { container: 'w-12 h-12', svg: 32 },
  md: { container: 'w-14 h-14', svg: 38 },
  lg: { container: 'w-20 h-20', svg: 54 },
  xl: { container: 'w-32 h-32', svg: 86 },
};

export const Logo: React.FC<LogoProps> = ({ size = 'md', onClick, className = '' }) => {
  const { container, svg } = sizeMap[size];

  return (
    <div
      className={`${container} rounded-full bg-navy flex items-center justify-center shadow-button ${onClick ? 'cursor-pointer hover:opacity-90 active:scale-95 transition-all' : ''} ${className}`}
      onClick={onClick}
    >
      <svg
        width={svg}
        height={svg}
        viewBox="0 0 100 100"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        {/* Stylized "M" with two curved orange shapes */}
        <path
          d="M25 75 C25 45, 35 25, 50 25 C45 35, 42 50, 42 75"
          stroke="#E8863A"
          strokeWidth="8"
          strokeLinecap="round"
          fill="none"
        />
        <path
          d="M50 25 C65 25, 75 45, 75 75"
          stroke="#E8863A"
          strokeWidth="8"
          strokeLinecap="round"
          fill="none"
        />
        <path
          d="M58 75 C58 50, 55 35, 50 25"
          stroke="#E8863A"
          strokeWidth="8"
          strokeLinecap="round"
          fill="none"
        />
      </svg>
    </div>
  );
};
