// StudentContext.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';

interface Student {
    StudentId: number;
    UserId: number;
    Name: string;
    DateOfBirth: string;
    ClassId: number;
    SDTPH: string;
    id: string;
}

interface StudentContextProps {
    selectedStudent: Student | null;
    setSelectedStudent: (student: Student) => void;
}

const StudentContext = createContext<StudentContextProps | undefined>(undefined);

export const StudentProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [selectedStudent, setSelectedStudent] = useState<Student | null>(null);

    return (
        <StudentContext.Provider value={{ selectedStudent, setSelectedStudent }}>
            {children}
        </StudentContext.Provider>
    );
};

export const useStudent = () => {
    const context = useContext(StudentContext);
    if (context === undefined) {
        throw new Error('useStudent must be used within a StudentProvider');
    }
    return context;
};
