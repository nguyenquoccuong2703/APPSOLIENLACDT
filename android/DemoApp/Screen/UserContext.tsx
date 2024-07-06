import React, { createContext, useState, useContext, ReactNode } from 'react';

interface User {
  id: string;
  UserName: string;
  PassWord: string;
  UserType: string;
}

interface Student {
  StudentId: number;
  UserId: number;
  Name: string;
  DateOfBirth: string;
  ClassId: number;
  SDTPH: string;
}

interface UserContextType {
  user: User | null;
  setUser: (user: User | null) => void;
  selectedStudent: Student | null;
  setSelectedStudent: (student: Student | null) => void;
}

const UserContext = createContext<UserContextType | undefined>(undefined);

export const UserProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [selectedStudent, setSelectedStudent] = useState<Student | null>(null);

  return (
    <UserContext.Provider value={{ user, setUser, selectedStudent, setSelectedStudent }}>
      {children}
    </UserContext.Provider>
  );
};

export const useUser = (): UserContextType => {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within a UserProvider');
  }
  return context;
};

export { UserContext }; // Exporting UserContext
