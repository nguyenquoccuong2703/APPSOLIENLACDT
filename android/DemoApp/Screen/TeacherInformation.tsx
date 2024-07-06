import { useEffect, useState } from 'react';
import axios from 'axios';
import { useUser } from './UserContext';

interface ApiResponse {
    users: any[]; // Update this type definition based on your actual data structure
    Teacher: Teacher[];
}

interface Teacher {
    id: number;
    UserID: number;
    Name: string;
    SubjectTC: string;
    SDT: string;
}

const useTeacherInformation = () => {
    const { user } = useUser();
    const [teacherData, setTeacherData] = useState<Teacher | null>(null);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchTeacherData = async () => {
                const response = await axios.get<ApiResponse>('http://192.168.137.1:3000/data');
                const data = response.data;
        
                console.log('API response:', data);
        
                if (!data.users || !data.Teacher) {
                    throw new Error('Malformed API response: Missing users or Teacher');
                }
        
                const currentUser = data.users.find((u: any) => u.UserName === user?.UserName);
                if (!currentUser) {
                    throw new Error('User not found');
                }
        
                const teacher = data.Teacher.find((t: Teacher) => t.UserID === currentUser.id);
                if (!teacher) {
                    throw new Error('Teacher not found for this user');
                }  
                setTeacherData(teacher);
        };
        if (user) {
            fetchTeacherData();
        }
    }, [user]);

    return { teacherData, error };
};
export { useTeacherInformation };
