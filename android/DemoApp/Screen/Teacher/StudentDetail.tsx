import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator, Alert, TouchableOpacity, ListRenderItem } from 'react-native';
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
    UserId: number;
    Name: string;
    DateOfBirth: string;
    ClassId: number;
    SDTPH: string;
}

interface Class {
    ClassId: number;
    ClassName: string;
    TeacherId: number;
    AcademicYear: number;
    GradeId: number;
}

interface Teacher {
    id: number;
    UserID: number;
    Name: string;
    SubjectTC: string;
    SDT: string;
}

interface Subject {
    SubjectId: number;
    SubjectName: string;
}

const StudentDetail: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'StudentDetail'>>();
    const { studentId } = route.params;
    const { user } = useUser();
    const [scores, setScores] = useState<Score[]>([]);
    const [student, setStudent] = useState<Student | null>(null);
    const [classes, setClasses] = useState<Class[]>([]);
    const [selectedYear, setSelectedYear] = useState<number | null>(null);
    const [teachers, setTeachers] = useState<{ [key: number]: string }>({});
    const [subjects, setSubjects] = useState<{ [key: number]: string }>({});
    const [selectedSemester, setSelectedSemester] = useState<number | null>(null);
    const [error, setError] = useState('');

    const fetchScoresAndDetails = async () => {
        try {
            const [scoresResponse, studentResponse, classesResponse, teachersResponse, subjectsResponse] = await Promise.all([
                fetch(`http://192.168.137.1:3000/Score?StudentId=${studentId}`),
                fetch(`http://192.168.137.1:3000/Student?StudentId=${studentId}`),
                fetch(`http://192.168.137.1:3000/Class`),
                fetch(`http://192.168.137.1:3000/Teacher`),
                fetch(`http://192.168.137.1:3000/Subject`)
            ]);

            const scoresData = await scoresResponse.json();
            const studentDataArray = await studentResponse.json();
            const classesData = await classesResponse.json();
            const teachersData = await teachersResponse.json();
            const subjectsData = await subjectsResponse.json();

            if (studentDataArray.length > 0) {
                setStudent(studentDataArray[0]);
            } else {
                setError('Student not found.');
            }

            const teachersMap: { [key: number]: string } = {};
            teachersData.forEach((teacher: Teacher) => {
                teachersMap[teacher.id] = teacher.Name;
            });
            setTeachers(teachersMap);

            const subjectsMap: { [key: number]: string } = {};
            subjectsData.forEach((subject: Subject) => {
                subjectsMap[subject.SubjectId] = subject.SubjectName;
            });
            setSubjects(subjectsMap);

            setScores(scoresData);
            setClasses(classesData);
        } catch (error) {
            console.error('Error fetching data:', error);
            setError('Lỗi khi lấy thông tin điểm.');
        }
    };

    useEffect(() => {
        if (studentId) {
            fetchScoresAndDetails();
        }
    }, [studentId]);

    const calculateAverageScores = (semesterScores: Score[]): Score | null => {
        if (semesterScores.length !== 2) return null;

        const averageScore = (score1: number, score2: number) => (score1 + score2) / 2;

        return {
            ...semesterScores[0],
            Scores1: averageScore(semesterScores[0].Scores1, semesterScores[1].Scores1),
            Scores2: averageScore(semesterScores[0].Scores2, semesterScores[1].Scores2),
            Scores3: averageScore(semesterScores[0].Scores3, semesterScores[1].Scores3),
            Score15: averageScore(semesterScores[0].Score15, semesterScores[1].Score15),
            GiuaKi: averageScore(semesterScores[0].GiuaKi, semesterScores[1].GiuaKi),
            CuoiKi: averageScore(semesterScores[0].CuoiKi, semesterScores[1].CuoiKi),
            Semester: 0,
        };
    };

    const filterScoresByYearAndSemester = (year: number | null, semester: number | null) => {
        let filteredScores = scores;
        if (year !== null) {
            const classIds = classes.filter(c => c.AcademicYear === year).map(c => c.ClassId);
            filteredScores = filteredScores.filter(score => classIds.includes(score.ClassId));
        }
        if (semester !== null) {
            filteredScores = filteredScores.filter(score => score.Semester === semester);
        } else {
            const semester1Scores = filteredScores.filter(score => score.Semester === 1 && classes.some(c => c.ClassId === score.ClassId && c.AcademicYear === year));
            const semester2Scores = filteredScores.filter(score => score.Semester === 2 && classes.some(c => c.ClassId === score.ClassId && c.AcademicYear === year));

            const combinedScores = semester1Scores.map((score1) => {
                const score2 = semester2Scores.find(score => score.SubjectTC === score1.SubjectTC);
                if (score2) {
                    return calculateAverageScores([score1, score2]);
                }
                return null;
            }).filter(score => score !== null) as Score[];

            return combinedScores;
        }
        return filteredScores;
    };

    const calculateFinalScore = (item: Score) => {
        const finalScore = (
            item.Scores1 + item.Scores2 + item.Scores3 + item.Score15 +
            item.GiuaKi * 2 + item.CuoiKi * 3
        ) / 9;
        return finalScore.toFixed(2);
    };

    const calculateYearlyFinalScore = (semester1Score: number, semester2Score: number) => {
        const yearlyFinalScore = (semester1Score + semester2Score * 2) / 3;
        return {
            semester1Score: semester1Score.toFixed(2),
            semester2Score: semester2Score.toFixed(2),
            yearlyFinalScore: yearlyFinalScore.toFixed(2),
        };
    };

    const getStudentClassification = (scores: Score[]) => {
        const finalScores = scores.map(score => parseFloat(calculateFinalScore(score)));
        const averageScore = finalScores.reduce((acc, curr) => acc + curr, 0) / finalScores.length;
        const allAbove = (threshold: number) => finalScores.every(score => score >= threshold);
        const specificSubjectsAbove = (subjects: number[], threshold: number) =>
            scores.filter(score => subjects.includes(score.SubjectTC)).every(score => parseFloat(calculateFinalScore(score)) >= threshold);

        if (averageScore > 8 && allAbove(6.5)) {
            return 'Học sinh giỏi';
        } else if (averageScore > 6.5 && specificSubjectsAbove([1, 5], 6.5) && allAbove(5)) {
            return 'Học sinh khá';
        } else {
            return 'Học sinh trung bình';
        }
    };

    const renderScoreHeader = () => (
        <View style={styles.tableRow}>
            <Text style={[styles.tableCell, styles.headerCell]}>Môn</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 1</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 2</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Miệng 3</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>15 phút</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Giữa Kì</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Cuối Kì</Text>
            <Text style={[styles.tableCell, styles.headerCell]}>Tổng Kết</Text>
        </View>
    );

    const renderScoreRow: ListRenderItem<Score> = ({ item }) => (
        <View style={styles.tableRow}>
            <Text style={styles.tableCell}>{subjects[item.SubjectTC] || 'Loading...'}</Text>
            <Text style={styles.tableCell}>{item.Scores1}</Text>
            <Text style={styles.tableCell}>{item.Scores2}</Text>
            <Text style={styles.tableCell}>{item.Scores3}</Text>
            <Text style={styles.tableCell}>{item.Score15}</Text>
            <Text style={styles.tableCell}>{item.GiuaKi}</Text>
            <Text style={styles.tableCell}>{item.CuoiKi}</Text>
            <Text style={styles.tableCell}>{calculateFinalScore(item)}</Text>
        </View>
    );

    const renderYearlyScoreRow: ListRenderItem<Score> = ({ item }) => {
        const semester1Score = scores.find(score => score.SubjectTC === item.SubjectTC && score.Semester === 1 && classes.some(c => c.ClassId === score.ClassId && c.AcademicYear === selectedYear));
        const semester2Score = scores.find(score => score.SubjectTC === item.SubjectTC && score.Semester === 2 && classes.some(c => c.ClassId === score.ClassId && c.AcademicYear === selectedYear));

        let yearlyScores = { semester1Score: 'N/A', semester2Score: 'N/A', yearlyFinalScore: 'N/A' };
        if (semester1Score && semester2Score) {
            yearlyScores = calculateYearlyFinalScore(parseFloat(calculateFinalScore(semester1Score)), parseFloat(calculateFinalScore(semester2Score)));
        }

        return (
            <View style={styles.tableRow}>
                <Text style={styles.tableCell}>{subjects[item.SubjectTC] || 'Loading...'}</Text>
                <Text style={styles.tableCell}>{yearlyScores.semester1Score}</Text>
                <Text style={styles.tableCell}>{yearlyScores.semester2Score}</Text>
                <Text style={styles.tableCell}>{yearlyScores.yearlyFinalScore}</Text>
            </View>
        );
    };

    const renderClassificationRow = () => {
        return (
            <View style={styles.tableRow}>
                <Text style={[styles.tableCell, { fontWeight: 'bold' }]}>Xếp loại</Text>
                <Text style={[styles.tableCell, { fontWeight: 'bold', flex: 3 }]}>{getStudentClassification(filteredScores)}</Text>
            </View>
        );
    };

    const renderYearItem: ListRenderItem<number> = ({ item }) => (
        <TouchableOpacity 
            style={[styles.classItem, selectedYear === item && styles.selectedClassItem]} 
            onPress={() => {
                setSelectedYear(item);
                setSelectedSemester(1); // Reset to first semester when selecting a new year
            }}
        >
            <Text style={[styles.classItemText, selectedYear === item && styles.selectedClassItemText]}>
                {item}
            </Text>
        </TouchableOpacity>
    );

    const uniqueYears = Array.from(new Set(classes.map(c => c.AcademicYear)));

    const filteredScores = filterScoresByYearAndSemester(selectedYear, selectedSemester);

    return (
        <View style={styles.container}>
            {error ? <Text style={styles.errorText}>{error}</Text> : null}
            {student && (
                <View style={styles.header}>
                    <Text style={styles.studentName}>{student.Name}</Text>
                </View>
            )}
            <View style={styles.classListContainer}>
                <FlatList
                    data={uniqueYears}
                    renderItem={renderYearItem}
                    keyExtractor={(item) => item.toString()}
                    horizontal
                    contentContainerStyle={styles.classList}
                />
            </View>
            {selectedYear !== null && (
                <View>
                    <View style={styles.buttonContainer}>
                        <TouchableOpacity
                            style={[styles.button, selectedSemester === 1 && styles.selectedButton]}
                            onPress={() => setSelectedSemester(1)}
                        >
                            <Text style={styles.buttonText}>Kỳ 1</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={[styles.button, selectedSemester === 2 && styles.selectedButton]}
                            onPress={() => setSelectedSemester(2)}
                        >
                            <Text style={styles.buttonText}>Kỳ 2</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={[styles.button, selectedSemester === null && styles.selectedButton]}
                            onPress={() => setSelectedSemester(null)}
                        >
                            <Text style={styles.buttonText}>Cả Năm</Text>
                        </TouchableOpacity>
                    </View>
                    {filteredScores.length === 0 ? (
                        <Text style={styles.noScoresText}>No scores available.</Text>
                    ) : (
                        <View>
                            {selectedSemester === null ? (
                                <View>
                                    <View style={styles.tableRow}>
                                        <Text style={[styles.tableCell, styles.headerCell]}>Môn</Text>
                                        <Text style={[styles.tableCell, styles.headerCell]}>Kỳ 1</Text>
                                        <Text style={[styles.tableCell, styles.headerCell]}>Kỳ 2</Text>
                                        <Text style={[styles.tableCell, styles.headerCell]}>Tổng Cả Năm</Text>
                                    </View>
                                    <FlatList
                                        data={filteredScores}
                                        renderItem={renderYearlyScoreRow}
                                        keyExtractor={(item) => `${item.ScoreId}-${item.Semester}-${item.SubjectTC}`}
                                        contentContainerStyle={styles.list}
                                        ListFooterComponent={renderClassificationRow}
                                    />
                                </View>
                            ) : (
                                <View>
                                    {renderScoreHeader()}
                                    <FlatList
                                        data={filteredScores}
                                        renderItem={renderScoreRow}
                                        keyExtractor={(item) => `${item.ScoreId}-${item.Semester}-${item.SubjectTC}`}
                                        contentContainerStyle={styles.list}
                                    />
                                </View>
                            )}
                        </View>
                    )}
                </View>
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f8f9fa',
        padding: 10,
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginVertical: 10,
    },
    header: {
        padding: 20,
        backgroundColor: '#ffffff',
        marginBottom: 10,
        borderRadius: 10,
        borderWidth: 1,
        borderColor: '#ced4da',
        elevation: 3,
    },
    studentName: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#343a40',
        textAlign: 'center',
    },
    classificationText: {
        fontSize: 16,
        color: '#343a40',
        textAlign: 'center',
        marginTop: 10,
    },
    buttonContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        marginBottom: 10,
    },
    button: {
        paddingVertical: 10,
        paddingHorizontal: 20,
        backgroundColor: '#6c757d',
        marginHorizontal: 5,
        borderRadius: 5,
    },
    selectedButton: {
        backgroundColor: '#495057',
    },
    buttonText: {
        fontSize: 16,
        color: '#fff',
        fontWeight: 'bold',
    },
    scoresContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginBottom: 5,
    },
    scoreText: {
        fontSize: 16,
        color: '#343a40',
    },
    list: {
        paddingBottom: 20,
    },
    classListContainer: {
        marginBottom: 10,
    },
    classList: {
        paddingBottom: 10,
    },
    classItem: {
        padding: 10,
        backgroundColor: '#ffffff',
        margin: 10,
        borderRadius: 10,
        borderWidth: 1,
        borderColor: '#ced4da',
        elevation: 3,
        width: 80,
        height: 80,
        justifyContent: 'center',
        alignItems: 'center',
    },
    selectedClassItem: {
        backgroundColor: '#007bff',
        borderColor: '#0056b3',
    },
    classItemText: {
        fontSize: 16,
        color: '#343a40',
        fontWeight: 'bold',
    },
    selectedClassItemText: {
        color: '#fff',
    },
    noScoresText: {
        fontSize: 16,
        color: '#343a40',
        textAlign: 'center',
        marginTop: 20,
    },
    tableRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingVertical: 10,
        paddingHorizontal: 5,
        backgroundColor: '#ffffff',
        marginBottom: 2,
        borderRadius: 5,
        borderWidth: 1,
        borderColor: '#ced4da',
    },
    tableCell: {
        flex: 1,
        textAlign: 'center',
        fontSize: 14,
        color: '#343a40',
    },
    headerCell: {
        fontWeight: 'bold',
        backgroundColor: '#e9ecef',
        color: '#343a40',
    },
});

export default StudentDetail;
