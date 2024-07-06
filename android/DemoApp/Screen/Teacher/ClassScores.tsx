import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator, ScrollView, Button } from 'react-native';
import { RouteProp, useRoute } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';
import { useUser } from '../UserContext'; // Adjust the path to your UserContext

interface Score {
    ScoreId: number;
    StudentId: number;
    ClassId: number;
    TeacherId: number;
    Scores1: number;
    Scores2: number;
    Scores3: number;
    Score15: number;
    Score60: number;
    GiuaKi: number;
    CuoiKi: number;
    SubjectTC: number;
    Semester: number;
}

interface Student {
    StudentId: number;
    Name: string;
}

interface Teacher {
    id: number;
    UserID: number;
    Name: string;
    SubjectTC: number;
}

interface Class {
    ClassId: number;
    ClassName: string;
}

const ClassScores: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'ClassScores'>>();
    const { classId } = route.params;
    const { user } = useUser();
    const [scores, setScores] = useState<Score[]>([]);
    const [students, setStudents] = useState<Student[]>([]);
    const [teacher, setTeacher] = useState<Teacher | null>(null);
    const [classInfo, setClassInfo] = useState<Class | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [semester, setSemester] = useState(1); // Quản lý trạng thái của kì hiện tại

    useEffect(() => {
        const fetchTeacherInfo = async () => {
            setLoading(true);
            try {
                const teacherResponse = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${user?.id}`);
                const teacherData = await teacherResponse.json();
                const currentTeacher = teacherData[0]; // Assuming the teacher data is in an array

                setTeacher(currentTeacher);

                const [scoresResponse, studentsResponse, classResponse] = await Promise.all([
                    fetch(`http://192.168.137.1:3000/Score?ClassId=${classId}&TeacherId=${currentTeacher.id}&SubjectTC=${currentTeacher.SubjectTC}&Semester=${semester}`),
                    fetch(`http://192.168.137.1:3000/Student?ClassId=${classId}`),
                    fetch(`http://192.168.137.1:3000/Class?ClassId=${classId}`)
                ]);

                const scoresData = await scoresResponse.json();
                const studentsData = await studentsResponse.json();
                const classData = await classResponse.json();

                console.log('Fetched Scores:', scoresData);
                console.log('Fetched Students:', studentsData);
                console.log('Fetched Class Info:', classData);

                setScores(scoresData);
                setStudents(studentsData);
                setClassInfo(classData[0]); // Assuming class data is in an array
            } catch (error) {
                console.error('Lỗi khi lấy thông tin bảng điểm:', error);
                setError('Không thể lấy thông tin bảng điểm.');
            } finally {
                setLoading(false);
            }
        };

        if (user?.id) {
            fetchTeacherInfo();
        }
    }, [classId, user?.id, semester]);

    const renderScoreHeader = () => (
        <View style={[styles.tableRow, styles.headerRow]}>
            <Text style={[styles.tableCell, styles.headerCell, { minWidth: 150 }]}>Học sinh</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 1</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 2</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 3</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>15 phút</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Giữa Kì</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Cuối Kì</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Tổng Kết</Text>
        </View>
    );

    const calculateFinalScore = (item: Score) => {
        const scores1 = item.Scores1 ?? 0;
        const scores2 = item.Scores2 ?? 0;
        const scores3 = item.Scores3 ?? 0;
        const score15 = item.Score15 ?? 0;
        const score60 = item.Score60 ?? 0;
        const giuaKi = item.GiuaKi ?? 0;
        const cuoiKi = item.CuoiKi ?? 0;

        const finalScore = (
            scores1 + scores2 + scores3 + score15 +
            giuaKi * 2 + cuoiKi * 3
        ) / 10;
        return finalScore.toFixed(2);
    };

    const renderScoreRow = ({ item }: { item: Score }) => {
        const student = students.find(s => s.StudentId === item.StudentId);

        return (
            <View style={styles.tableRow}>
                <Text style={[styles.tableCell, { minWidth: 150 }]}>{student ? student.Name : 'Loading...'}</Text>
                <Text style={styles.tableCell}>{item.Scores1 ?? '-'}</Text>
                <Text style={styles.tableCell}>{item.Scores2 ?? '-'}</Text>
                <Text style={styles.tableCell}>{item.Scores3 ?? '-'}</Text>
                <Text style={styles.tableCell}>{item.Score15 ?? '-'}</Text>
                <Text style={styles.tableCell}>{item.GiuaKi ?? '-'}</Text>
                <Text style={styles.tableCell}>{item.CuoiKi ?? '-'}</Text>
                <Text style={styles.tableCell}>{calculateFinalScore(item)}</Text>
            </View>
        );
    };

    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>Bảng Điểm {classInfo ? `Lớp ${classInfo.ClassName}` : '...'}</Text>
            <View style={styles.buttonContainer}>
                <Button title="Kì 1" onPress={() => setSemester(1)} />
                <Button title="Kì 2" onPress={() => setSemester(2)} />
            </View>
            {loading ? (
                <ActivityIndicator size="large" color="#0000ff" />
            ) : error ? (
                <Text style={styles.errorText}>{error}</Text>
            ) : (
                <ScrollView horizontal>
                    <View>
                        {renderScoreHeader()}
                        <FlatList
                            data={scores.filter(score => score.SubjectTC === teacher?.SubjectTC && score.ClassId === classId && score.TeacherId === teacher?.id)}
                            renderItem={renderScoreRow}
                            keyExtractor={(item) => item.ScoreId.toString()}
                            contentContainerStyle={styles.list}
                        />
                    </View>
                </ScrollView>
            )}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f7f8fa',
        padding: 20,
    },
    headerText: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#333',
        marginBottom: 20,
    },
    buttonContainer: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        marginBottom: 20,
    },
    list: {
        marginTop: 20,
        width: '100%',
    },
    tableRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: 10,
        paddingHorizontal: 5,
        backgroundColor: '#ffffff',
        marginBottom: 2,
        borderRadius: 5,
        borderWidth: 1,
        borderColor: '#ddd',
    },
    headerRow: {
        backgroundColor: '#f1f1f1',
        borderBottomWidth: 1,
        borderBottomColor: '#ddd',
    },
    tableCell: {
        textAlign: 'center',
        fontSize: 14,
        color: '#343a40',
        paddingVertical: 10,
        minWidth: 70,
        paddingHorizontal: 5,
        flex: 1,
    },
    headerCell: {
        fontWeight: 'bold',
        color: '#343a40',
    },
    studentName: {
        textAlign: 'left',
        paddingLeft: 10,
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginVertical: 10,
    },
});

export default ClassScores;
