import React from 'react';

interface LogoProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  onClick?: () => void;
  className?: string;
  label?: string;
}

const sizeMap = {
  sm: { container: 'w-10 h-10', svg: 28, labelSize: 'text-[9px]' },
  md: { container: 'w-14 h-14', svg: 38, labelSize: 'text-[10px]' },
  lg: { container: 'w-20 h-20', svg: 54, labelSize: 'text-xs' },
  xl: { container: 'w-32 h-32', svg: 86, labelSize: 'text-sm' },
};

export const Logo: React.FC<LogoProps> = ({ size = 'md', onClick, className = '', label }) => {
  const { container, svg, labelSize } = sizeMap[size];

  return (
    <button
      type="button"
      className={`flex flex-col items-center gap-1 ${onClick ? 'cursor-pointer' : ''} ${className}`}
      onClick={onClick}
      disabled={!onClick}
    >
      <div
        className={`${container} rounded-full bg-navy flex items-center justify-center shadow-button ${onClick ? 'hover:opacity-90 active:scale-95 transition-all' : ''}`}
      >
        <svg
          width={svg}
          height={svg}
          viewBox="0 0 100 100"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          {/* Stylized "M" */}
          <path
            d="M25 75 C25 45, 35 25, 50 25 C45 35, 42 50, 42 75"
            stroke="#FFFFFF"
            strokeWidth="8"
            strokeLinecap="round"
            fill="none"
          />
          <path
            d="M50 25 C65 25, 75 45, 75 75"
            stroke="#FFFFFF"
            strokeWidth="8"
            strokeLinecap="round"
            fill="none"
          />
          <path
            d="M58 75 C58 50, 55 35, 50 25"
            stroke="#FFFFFF"
            strokeWidth="8"
            strokeLinecap="round"
            fill="none"
          />
        </svg>
      </div>
      {label && (
        <span className={`${labelSize} font-bold text-white uppercase tracking-wide`}>
          {label}
        </span>
      )}
    </button>
  );
};
