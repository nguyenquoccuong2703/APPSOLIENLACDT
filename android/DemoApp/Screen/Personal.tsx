import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { useUser } from './UserContext';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from './NavigationTypes';
import Icon from 'react-native-vector-icons/Ionicons';

const Personal: React.FC = () => {
  const { user } = useUser();
  const [error, setError] = useState('');
  const [successMessage, setSuccessMessage] = useState('');
  const [students, setStudents] = useState<any[]>([]);
  const [selectedStudent, setSelectedStudent] = useState<any>(null);
  const [classInfoStudent, setClassInfoStudent] = useState<any>(null);
  const [teacherInfoStudent, setTeacherInfoStudent] = useState<any>(null);
  const [parentInfo, setParentInfo] = useState<any>(null);
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();

  const fetchStudents = async () => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/Student?UserId=${user?.id}`);
      const data = await response.json();
      if (data.length > 0) {
        console.log('Fetched students:', data);
        setStudents(data);
        setSelectedStudent(data[0]);
        fetchClassInfoStudent(data[0].ClassId);
      } else {
        setError('Thông tin học sinh không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching student information:', error);
      setError('Lỗi khi lấy thông tin học sinh.');
    }
  };

  const fetchClassInfoStudent = async (classId: number) => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/Class?ClassId=${classId}`);
      const data = await response.json();
      if (data.length > 0) {
        console.log('Fetched class info:', data);
        setClassInfoStudent(data[0]);
        fetchTeacherInfoStudent(data[0].ClassId);
      } else {
        setError('Thông tin lớp học không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching class information:', error);
      setError('Lỗi khi lấy thông tin lớp học.');
    }
  };

  const fetchTeacherInfoStudent = async (classId: number) => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?ClassId=${classId}`);
      const data = await response.json();
      if (data.length > 0) {
        const teacherAssignment = data.find((assignment: any) => assignment.IsHeadTeacher === 1);
        if (teacherAssignment) {
          const teacherResponse = await fetch(`http://192.168.137.1:3000/Teacher?TeacherId=${teacherAssignment.TeacherId}`);
          const teacherData = await teacherResponse.json();
          if (teacherData.length > 0) {
            console.log('Fetched teacher info:', teacherData);
            setTeacherInfoStudent(teacherData[0]);
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

  const fetchParentInfo = async () => {
    try {
      const response = await fetch(`http://192.168.137.1:3000/Parent?UserID=${user?.id}`);
      const data = await response.json();
      if (data.length > 0) {
        console.log('Fetched parent info:', data);
        setParentInfo(data[0]);
      } else {
        setError('Thông tin phụ huynh không được tìm thấy.');
      }
    } catch (error) {
      console.error('Error fetching parent information:', error);
      setError('Lỗi khi lấy thông tin phụ huynh.');
    }
  };

  useEffect(() => {
    fetchStudents();
    fetchParentInfo();
  }, []);

  const renderStudentInfo = () => (
    <View style={styles.infoContainer}>
      <Text style={styles.sectionText}>Thông Tin Tài Khoản</Text>
      <Text style={styles.userInfo}>Tài Khoản: {user?.UserName}</Text>
      {selectedStudent ? (
        <>
          <Text style={styles.userInfo}>Tên: {selectedStudent.Name}</Text>
          <Text style={styles.userInfo}>Số điện thoại Phụ Huynh: {selectedStudent.SDTPH}</Text>
          <Text style={styles.userInfo}>Ngày Sinh: {selectedStudent.DateOfBirth}</Text>
          {classInfoStudent && <Text style={styles.userInfo}>Lớp: {classInfoStudent.ClassName}</Text>}
          {teacherInfoStudent && <Text style={styles.userInfo}>Giáo viên chủ nhiệm: {teacherInfoStudent.Name}</Text>}
        </>
      ) : (
        <Text style={styles.errorText}>{error || 'Loading...'}</Text>
      )}
    </View>
  );

  const renderParentInfo = () => (
    <View style={styles.infoContainer}>
      <Text style={styles.sectionText}>Thông Tin Phụ Huynh</Text>
      {parentInfo ? (
        <>
          <Text style={styles.userInfo}>Tên: {parentInfo.ParentName}</Text>
          <Text style={styles.userInfo}>Email: {parentInfo.ParentEmail}</Text>
        </>
      ) : (
        <Text style={styles.errorText}>{error || 'Loading...'}</Text>
      )}
    </View>
  );

  const renderChildrenInfo = () => (
    <View style={styles.infoContainer}>
      <Text style={styles.sectionText}>Các Con</Text>
      {students.map((student) => (
        <View key={student.StudentId} style={styles.childInfo}>
          <Text style={styles.userInfo}>Tên: {student.Name}</Text>
          <Text style={styles.userInfo}>Lớp: {classInfoStudent?.ClassName}</Text>
        </View>
      ))}
    </View>
  );

  return (
    <ScrollView style={styles.container}>
      <View>
        {user?.UserType === '1' && (
          <>
            <View style={styles.card}>{renderParentInfo()}</View>
            <View style={styles.card}>{renderChildrenInfo()}</View>
          </>
        )}
        {user?.UserType === '2' && selectedStudent && (
          <View style={styles.card}>{renderStudentInfo()}</View>
        )}
        <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('ChangePassword')}>
          <Icon name="lock-closed" size={20} color="white" />
          <Text style={styles.buttonText}>Đổi mật khẩu</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f2f2f2',
    padding: 20,
  },
  card: {
    backgroundColor: '#fff',
    padding: 20,
    marginVertical: 10,
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  infoContainer: {
    marginBottom: 20,
  },
  sectionText: {
    fontSize: 22,
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
  button: {
    flexDirection: 'row',
    backgroundColor: '#2196F3',
    borderRadius: 10,
    padding: 15,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 20,
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
    marginLeft: 10,
  },
  childInfo: {
    marginVertical: 5,
    paddingVertical: 10,
    borderTopWidth: 1,
    borderTopColor: '#ddd',
  },
});

export default Personal;
