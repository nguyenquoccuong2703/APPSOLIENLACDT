import React, { useState, useEffect } from 'react';
import { View, Text, Image, StyleSheet, ScrollView, Dimensions, TouchableOpacity, SafeAreaView } from 'react-native';
import { useUser } from '../UserContext';
import { useNavigation } from '@react-navigation/native';

const HomeTeacher: React.FC = () => {
    const { user } = useUser();
    const navigation = useNavigation();
    const [teacherInfo, setTeacherInfo] = useState<any>(null);
    const [headTeacherClass, setHeadTeacherClass] = useState<any>(null);
    const [classInfo, setClassInfo] = useState<any>(null);
    const [error, setError] = useState<string | null>(null);
    const [subjectName, setSubjectName] = useState<string | null>(null);
    const [notifications, setNotifications] = useState<any[]>([]);
    const [expandedNotificationIndex, setExpandedNotificationIndex] = useState<number | null>(null);

    const fetchTeacherInfo = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${user?.id}`);
            const data = await response.json();
            if (data.length > 0) {
                setTeacherInfo(data[0]);
            } else {
                setError('Teacher information not found.');
            }
        } catch (error) {
            console.error('Error fetching teacher information:', error);
            setError('Error fetching teacher information.');
        }
    };

    const fetchSubjectName = async (subjectId: string) => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Subject?SubjectId=${subjectId}`);
            const data = await response.json();
            if (data.length > 0) {
                setSubjectName(data[0].SubjectName);
            } else {
                console.log('Subject not found.');
            }
        } catch (error) {
            console.error('Error fetching subject:', error);
        }
    };

    const fetchHeadTeacherClass = async (teacherId: string) => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${teacherId}&IsHeadTeacher=1`);
            const data = await response.json();
            if (data.length > 0) {
                setHeadTeacherClass(data[0]);
                fetchClassInfo(data[0].ClassId);
            } else {
                setError('Head teacher class not found.');
            }
        } catch (error) {
            console.error('Error fetching head teacher class:', error);
            setError('Error fetching head teacher class.');
        }
    };

    const fetchClassInfo = async (classId: string) => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Class?ClassId=${classId}`);
            const data = await response.json();
            if (data.length > 0) {
                setClassInfo(data[0]);
            } else {
                setError('Class information not found.');
            }
        } catch (error) {
            console.error('Error fetching class information:', error);
            setError('Error fetching class information.');
        }
    };

    const fetchNotifications = async () => {
        try {
            const response = await fetch('http://192.168.137.1:3000/Notifications');
            const data = await response.json();
            setNotifications(data);
        } catch (error) {
            console.error('Error fetching notifications:', error);
        }
    };

    useEffect(() => {
        fetchTeacherInfo();
        fetchNotifications();
    }, []);

    useEffect(() => {
        if (teacherInfo) {
            fetchHeadTeacherClass(teacherInfo.id);
        }
    }, [teacherInfo]);

    useEffect(() => {
        if (teacherInfo) {
            fetchSubjectName(teacherInfo.SubjectTC);
        }
    }, [teacherInfo]);

    const handleNotificationPress = (index: number) => {
        setExpandedNotificationIndex(expandedNotificationIndex === index ? null : index);
    };

    const latestNotifications = notifications.slice(0, 2); // Get the two most recent notifications

    return (
        <SafeAreaView style={styles.container}>
            <View style={styles.headerContainer}>
                <Image style={styles.logo} source={require('/Users/nguye/Demo/android/DemoApp/Images/LogoHUIT.png')} />
                <Text style={styles.txt}></Text>
                <TouchableOpacity onPress={() => navigation.navigate('Settings' as never)}>
                    <Image style={styles.notification} source={require('/Users/nguye/Demo/android/DemoApp/Images/sign-out-alt.png')} />
                </TouchableOpacity>
            </View>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Thông Tin Tài Khoản</Text>
                    <Text style={styles.userInfo}>Tài Khoản: {user?.UserName}</Text>
                    {teacherInfo ? (
                        <>
                            <Text style={styles.userInfo}>Tên: {teacherInfo.Name}</Text>
                            <Text style={styles.userInfo}>Số điện thoại: {teacherInfo.SDT}</Text>
                        </>
                    ) : (
                        <Text style={styles.errorText}>{error || 'Loading...'}</Text>
                    )}
                    {headTeacherClass && (
                        <View>
                            <Text style={styles.userInfo}>Chủ Nhiệm Lớp: {classInfo ? classInfo.ClassName : headTeacherClass.ClassId}</Text>
                        </View>
                    )}
                    <Text style={styles.userInfo}>Dạy Môn: {subjectName || 'Loading...'}</Text>
                </View>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Thông Báo</Text>
                    {latestNotifications.length > 0 ? (
                        latestNotifications.map((notification, index) => (
                            <TouchableOpacity key={index} onPress={() => handleNotificationPress(index)}>
                                <View style={[styles.notificationItem, expandedNotificationIndex === index && styles.expandedNotificationItem]}>
                                    <Text style={styles.notificationTitle}>{notification.NameContent}</Text>
                                    {expandedNotificationIndex === index && (
                                        <>
                                            <Text style={styles.notificationContent}>{notification.Content.replace(/<\/br>/g, '\n')}</Text>
                                            <Text style={styles.notificationTimestamp}>{notification.Timestamp}</Text>
                                        </>
                                    )}
                                </View>
                            </TouchableOpacity>
                        ))
                    ) : (
                        <Text style={styles.noNotificationText}>Không có thông báo nào.</Text>
                    )}
                </View>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Ứng Dụng</Text>
                    <View style={styles.buttonsContainer}>
                        <TouchableOpacity onPress={() => navigation.navigate('Personal' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/user.png')} />
                                    <Text style={styles.text}>Tài Khoản</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => navigation.navigate('AttendanceTeacher' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/users.png')} />
                                    <Text style={styles.text}>Điểm Danh</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => navigation.navigate('TimetableTeacher' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/calendar.png')} />
                                    <Text style={styles.text}>Thời Khóa Biểu</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => navigation.navigate('NotificationsTeacher' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/bell.png')} />
                                    <Text style={styles.text}>Thông Báo</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => navigation.navigate('LeaveRequestsTeacher' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/bed.png')} />
                                    <Text style={styles.text}>Phép Nghỉ</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => navigation.navigate('NewsList' as never)}>
                            <View style={styles.item}>
                                <View style={styles.square}>
                                    <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/newspaper.png')} />
                                    <Text style={styles.text}>Tin Tức</Text>
                                </View>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>
            </ScrollView>
        </SafeAreaView>
    );
}

const { width } = Dimensions.get('window');
const itemSize = (width - 60) / 3; // 3 items in a row with some padding

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f0f0f0', // Màu nền nhẹ nhàng hơn
    },
    headerContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 20,
        paddingVertical: 10,
        backgroundColor: '#ffffff',
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    logo: {
        width: 100,
        height: 60,
        resizeMode: 'contain',
    },
    txt: {
        flex: 1,
        fontSize: 18,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    notification: {
        width: 25,
        height: 25,
        marginLeft: 10,
    },
    scrollViewContainer: {
        flexGrow: 1,
        paddingBottom: 100, // Adjusted padding to prevent content from being hidden by the tab bar
    },
    expandedNotificationItem: {
        maxHeight: null, // allow expanded notifications to grow
    },
    card: {
        width: '90%',
        backgroundColor: '#fff',
        padding: 20,
        marginVertical: 10,
        borderRadius: 15, // Bo tròn các góc
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
    },
    userInfo: {
        fontSize: 16,
        color: '#555',
        marginBottom: 5,
    },
    errorText: {
        fontSize: 16,
        color: 'red',
    },
    notificationItem: {
        marginBottom: 15,
        padding: 10,
        backgroundColor: '#e9e9e9',
        borderRadius: 15,
        borderWidth: 1,
        borderColor: '#ddd',
        minHeight: 100,
        maxHeight: 100,
        justifyContent: 'center',
        textAlign: 'center',
        flexShrink: 1,
        overflow: 'hidden',
    },
    notificationTitle: {
        fontSize: 16,
        fontWeight: 'bold',
        marginBottom: 5,
        overflow: 'hidden',
    },
    notificationContent: {
        fontSize: 14,
        marginBottom: 5,
        color: '#333',
    },
    notificationTimestamp: {
        fontSize: 12,
        color: '#666',
        textAlign: 'right',
    },
    noNotificationText: {
        fontSize: 14,
        color: '#000',
    },
    buttonsContainer: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'space-around',
    },
    item: {
        width: itemSize,
        margin: 5,
    },
    square: {
        width: '100%',
        aspectRatio: 1,
        backgroundColor: '#ffffff',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 10,
        borderRadius: 15,
        borderWidth: 1,
        borderColor: '#ddd',
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    image: {
        width: 30,
        height: 30,
        marginBottom: 10,
    },
    text: {
        fontSize: 14,
        textAlign: 'center',
        color: '#333',
        fontWeight: 'bold',
    },
});

export default HomeTeacher;
