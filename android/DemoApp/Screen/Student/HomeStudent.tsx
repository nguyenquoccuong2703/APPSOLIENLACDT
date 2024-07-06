import React, { useState, useEffect, useContext } from 'react';
import {
  View,
  Text,
  Image,
  StyleSheet,
  ScrollView,
  FlatList,
  TouchableOpacity,
  SafeAreaView,
  Dimensions,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { UserContext } from '../UserContext';

const HomeStudent: React.FC = () => {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within a UserProvider');
  }
  const { user, selectedStudent, setSelectedStudent } = context;
  const navigation = useNavigation();
  const [error, setError] = useState<string | null>(null);
  const [students, setStudents] = useState<any[]>([]);
  const [classInfo, setClassInfo] = useState<any>(null);
  const [teacherInfo, setTeacherInfo] = useState<any>(null);
  const [notifications, setNotifications] = useState<any[]>([]);
  const [expandedNotificationIndex, setExpandedNotificationIndex] = useState<number | null>(null);

  useEffect(() => {
    fetchStudents();
    fetchNotifications();
  }, []);

  useEffect(() => {
    if (selectedStudent) {
      fetchClassInfo(selectedStudent.ClassId);
    }
  }, [selectedStudent]);

  const fetchStudents = async () => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/Student?UserId=${user?.id}`);
      const data = await response.json();
      if (data.length > 0) {
        setStudents(data);
        setSelectedStudent(data[0]);
      } else {
        setError('Thông tin học sinh không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching student information:', error);
      setError('Lỗi khi lấy thông tin học sinh.');
    }
  };

  const fetchClassInfo = async (classId: number) => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/Class?ClassId=${classId}`);
      const data = await response.json();
      if (data.length > 0) {
        setClassInfo(data[0]);
        fetchTeacherInfo(data[0].ClassId);
      } else {
        setError('Thông tin lớp học không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching class information:', error);
      setError('Lỗi khi lấy thông tin lớp học.');
    }
  };

  const fetchTeacherInfo = async (classId: number) => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?ClassId=${classId}`);
      const data = await response.json();
      if (data.length > 0) {
        const teacherAssignment = data.find((assignment: any) => assignment.IsHeadTeacher === 1);
        if (teacherAssignment) {
          const teacherResponse = await fetch(`http://192.168.137.1:3000/Teacher?TeacherId=${teacherAssignment.TeacherId}`);
          const teacherData = await teacherResponse.json();
          if (teacherData.length > 0) {
            setTeacherInfo(teacherData[0]);
          } else {
            setError('Thông tin giáo viên không được tìm thấy.');
          }
        } else {
          setError('Không có giáo viên chủ nhiệm cho lớp học này.');
        }
      } else {
        setError('Thông tin giáo viên chủ nhiệm không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching teacher information:', error);
      setError('Lỗi khi lấy thông tin giáo viên.');
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

  const handleNotificationPress = (index: number) => {
    setExpandedNotificationIndex(expandedNotificationIndex === index ? null : index);
  };

  const latestNotifications = notifications.slice(0, 2);

  const renderStudentItem = ({ item }: { item: any }) => (
    <TouchableOpacity onPress={() => setSelectedStudent(item)} style={styles.studentButton}>
      <Text style={styles.studentButtonText}>{item.Name}</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.headerContainer}>
        <Image style={styles.logo} source={require('/Users/nguye/Demo/android/DemoApp/Images/LogoHUIT.png')} />
        <TouchableOpacity onPress={() => navigation.navigate('Settings' as never)}>
          <Image style={styles.notification} source={require('/Users/nguye/Demo/android/DemoApp/Images/sign-out-alt.png')} />
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={styles.scrollViewContainer}>
        <View style={styles.card}>
          <FlatList
            data={students}
            renderItem={renderStudentItem}
            keyExtractor={(item) => item.StudentId.toString()}
            horizontal
            showsHorizontalScrollIndicator={false}
            style={styles.horizontalList}
            contentContainerStyle={styles.horizontalListContent}
          />
        </View>
        {selectedStudent && (
          <View style={styles.card}>
            <Text style={styles.sectionText}>Thông Tin Học Sinh</Text>
            <>
              <Text style={styles.userInfo}>Tên: {selectedStudent.Name}</Text>
              <Text style={styles.userInfo}>SDT Phụ Huynh: {selectedStudent.SDTPH}</Text>
              <Text style={styles.userInfo}>Ngày Sinh: {selectedStudent.DateOfBirth}</Text>
              {classInfo && <Text style={styles.userInfo}>Lớp: {classInfo.ClassName}</Text>}
              {teacherInfo && <Text style={styles.userInfo}>Giáo viên chủ nhiệm: {teacherInfo.Name}</Text>}
            </>
          </View>
        )}
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
            <TouchableOpacity onPress={() => navigation.navigate('Attendance' as never)}>
              <View style={styles.item}>
                <View style={styles.square}>
                  <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/users.png')} />
                  <Text style={styles.text}>Điểm Danh</Text>
                </View>
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => navigation.navigate('Timetable' as never)}>
              <View style={styles.item}>
                <View style={styles.square}>
                  <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/calendar.png')} />
                  <Text style={styles.text}>Thời Khóa Biểu</Text>
                </View>
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => navigation.navigate('Notifications' as never)}>
              <View style={styles.item}>
                <View style={styles.square}>
                  <Image style={styles.image} source={require('/Users/nguye/Demo/android/DemoApp/Images/bell.png')} />
                  <Text style={styles.text}>Thông Báo</Text>
                </View>
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => navigation.navigate('LeaveRequests' as never)}>
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
};

const { width } = Dimensions.get('window');
const itemSize = (width - 60) / 3; // 3 items in a row with some padding

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f0f0f0',
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
  notification: {
    width: 25,
    height: 25,
    marginLeft: 10,
  },
  scrollViewContainer: {
    flexGrow: 1,
    paddingBottom: 100,
  },
  expandedNotificationItem: {
    maxHeight: null,
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
  studentButton: {
    backgroundColor: '#2196F3',
    padding: 10,
    borderRadius: 5,
    marginRight: 10,
    minWidth: 100, // Added this line to make the buttons have equal width
    alignItems: 'center', // Center the text
  },
  studentButtonText: {
    color: '#fff',
    fontSize: 16,
    textAlign: 'center',
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
  horizontalList: {
    marginTop: 10,
  },
  horizontalListContent: {
    paddingHorizontal: 10,
  },
});

export default HomeStudent;
