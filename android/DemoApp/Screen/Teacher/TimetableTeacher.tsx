import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView, Modal, TouchableOpacity } from 'react-native';
import { useUser } from '../UserContext';
import { Calendar } from 'react-native-calendars';

interface TimetableItem {
    ClassId: number;
    Times: string;
    Date: string;
    SubjectId: number;
    TeacherID: number;
}

interface Subject {
    SubjectId: number;
    SubjectName: string;
}

interface Teacher {
    id: string;
    Name: string;
}

interface Class {
    ClassId: number;
    ClassName: string;
    GradeId: number;
}

interface Grade {
    GradeID: number;
    Grade: string;
}

const TimetableTeacher: React.FC = () => {
    const { user } = useUser();
    const [timetable, setTimetable] = useState<TimetableItem[]>([]);
    const [subjects, setSubjects] = useState<Subject[]>([]);
    const [teachers, setTeachers] = useState<Teacher[]>([]);
    const [classes, setClasses] = useState<Class[]>([]);
    const [grades, setGrades] = useState<Grade[]>([]);
    const [selectedDate, setSelectedDate] = useState<string | null>(null);
    const [selectedDetails, setSelectedDetails] = useState<TimetableItem[]>([]);
    const [modalVisible, setModalVisible] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [teacherInfo, setTeacherInfo] = useState<any>(null);

    const fetchTeacherInfo = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${user?.id}`);
            const data = await response.json();
            if (data.length > 0) {
                setTeacherInfo(data[0]);
                fetchTimetable(data[0].id);
            } else {
                setError('Thông tin giáo viên không được tìm thấy.');
            }
        } catch (error) {
            console.error('Lỗi khi lấy thông tin giáo viên:', error);
            setError('Lỗi khi lấy thông tin giáo viên.');
        }
    };

    const fetchTimetable = async (teacherId: string) => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Timetable?TeacherID=${teacherId}`);
            const data: TimetableItem[] = await response.json();
            setTimetable(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin thời khóa biểu:', error);
            setError('Lỗi khi lấy thông tin thời khóa biểu.');
        }
    };

    const fetchSubjects = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Subject`);
            const data: Subject[] = await response.json();
            setSubjects(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin môn học:', error);
        }
    };

    const fetchTeachers = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Teacher`);
            const data: Teacher[] = await response.json();
            setTeachers(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin giáo viên:', error);
        }
    };

    const fetchClasses = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Class`);
            const data: Class[] = await response.json();
            setClasses(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin lớp:', error);
        }
    };

    const fetchGrades = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Grade`);
            const data: Grade[] = await response.json();
            setGrades(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin khối:', error);
        }
    };

    useEffect(() => {
        fetchTeacherInfo();
        fetchSubjects();
        fetchTeachers();
        fetchClasses();
        fetchGrades();
    }, []);

    const getSubjectName = (subjectId: number) => {
        const subject = subjects.find(sub => sub.SubjectId === subjectId);
        return subject ? subject.SubjectName : '';
    };

    const getTeacherName = (teacherId: number) => {
        const teacher = teachers.find(teach => teach.id === teacherId.toString())
        return teacher ? teacher.Name : 'Không có thông tin giáo viên';
    };

    const getClassName = (classId: number) => {
        const classInfo = classes.find(cls => cls.ClassId === classId);
        if (classInfo) {
            const grade = grades.find(gr => gr.GradeID === classInfo.GradeId);
            const gradeName = grade ? grade.Grade : '';
            return `Lớp ${classInfo.GradeId}${classInfo.ClassName} `;
        }
        return 'Không có thông tin lớp';
    };

    const getMarkedDates = () => {
        const markedDates: { [key: string]: { selected: boolean, selectedColor: string } } = {};
        timetable.forEach((tt) => {
            markedDates[tt.Date] = { selected: true, selectedColor: '#50C878' };
        });
        return markedDates;
    };

    const handleDayPress = (day: any) => {
        const date = day.dateString;
        const lessons = timetable.filter(lesson => lesson.Date === date);
        if (lessons.length > 0) {
            setSelectedDate(date);
            setSelectedDetails(lessons);
            setModalVisible(true);
        } else {
            console.log('Không có bài học nào cho ngày đã chọn.');
        }
    };

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Thời Khóa Biểu</Text>
                    {error ? (
                        <Text style={styles.errorText}>{error}</Text>
                    ) : (
                        <Calendar
                            markedDates={getMarkedDates()}
                            onDayPress={handleDayPress}
                        />
                    )}
                </View>
                <Modal
                    animationType="slide"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => {
                        setModalVisible(!modalVisible);
                    }}
                >
                    <View style={styles.modalContainer}>
                        <View style={styles.modalView}>
                            <Text style={styles.modalText}>Thông tin dạy ngày {selectedDate}</Text>
                            <View style={styles.tableContainer}>
                                <View style={styles.tableHeader}>
                                    <Text style={[styles.tableCell, styles.headerCell]}>Thời gian</Text>
                                    <Text style={[styles.tableCell, styles.headerCell]}>Môn học</Text>
                                    <Text style={[styles.tableCell, styles.headerCell]}>Lớp</Text>
                                </View>
                                {selectedDetails.map((lesson, index) => (
                                    <View key={index} style={styles.tableRow}>
                                        <Text style={styles.tableCell}>{lesson.Times}</Text>
                                        <Text style={styles.tableCell}>{getSubjectName(lesson.SubjectId)}</Text>
                                        <Text style={styles.tableCell}>{getClassName(lesson.ClassId)}</Text>
                                    </View>
                                ))}
                            </View>
                            <TouchableOpacity
                                style={[styles.button, styles.buttonClose]}
                                onPress={() => setModalVisible(!modalVisible)}
                            >
                                <Text style={styles.textStyle}>Đóng</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
            </ScrollView>
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f0f0f0',
    },
    scrollViewContainer: {
        flexGrow: 1,
        paddingBottom: 20,
    },
    card: {
        width: '90%',
        backgroundColor: '#fff',
        padding: 20,
        marginVertical: 10,
        borderRadius: 15,
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
        alignSelf: 'center',
    },
    sectionText: {
        fontSize: 20,
        color: '#333',
        marginBottom: 10,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
    },
    modalContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 22,
    },
    modalView: {
        margin: 20,
        backgroundColor: 'white',
        borderRadius: 20,
        padding: 35,
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 4,
        elevation: 5,
        width: '90%',
    },
    button: {
        borderRadius: 20,
        padding: 10,
        elevation: 2,
    },
    buttonClose: {
        backgroundColor: '#2196F3',
        marginTop: 20,
    },
    textStyle: {
        color: 'white',
        fontWeight: 'bold',
        textAlign: 'center',
    },
    modalText: {
        marginBottom: 15,
        textAlign: 'center',
        fontSize: 18,
        fontWeight: 'bold',
    },
    tableContainer: {
        width: '100%',
        marginVertical: 10,
    },
    tableHeader: {
        flexDirection: 'row',
        backgroundColor: '#f0f0f0',
    },
    tableRow: {
        flexDirection: 'row',
        borderBottomWidth: 1,
        borderBottomColor: '#ddd',
    },
    tableCell: {
        flex: 1,
        padding: 10,
        textAlign: 'left',
    },
    headerCell: {
        fontWeight: 'bold',
        backgroundColor: '#e0e0e0',
    },
    lessonDetails: {
        marginBottom: 10,
    },
});

export default TimetableTeacher;