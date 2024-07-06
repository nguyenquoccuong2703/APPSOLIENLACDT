import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Ionicons from 'react-native-vector-icons/Ionicons';
import HomeTeacher from './android/DemoApp/Screen/Teacher/HomeTeacher';
import LoginScreen from './android/DemoApp/Screen/LoginScreen';
import HomeStudent from './android/DemoApp/Screen/Student/HomeStudent';
import { RootStackParamList } from './android/DemoApp/Screen/NavigationTypes';
import ResultTeacher from './android/DemoApp/Screen/Teacher/ResultTeacher';
import ResultStudent from './android/DemoApp/Screen/Student/ResultStudent';
import Personal from './android/DemoApp/Screen/Personal';
import ContactsScreen from './android/DemoApp/Screen/ContactsScreen';
import { UserProvider } from './android/DemoApp/Screen/UserContext';
import Settings from './android/DemoApp/Screen/Settings';
import ChangePassword from './android/DemoApp/Screen/ChangePassword';
import Attendance from './android/DemoApp/Screen/Student/Attendance';
import Timetable from './android/DemoApp/Screen/Student/Timetable';
import LeaveRequests from './android/DemoApp/Screen/Student/LeaveRequests';
import NewsList from './android/DemoApp/Screen/Student/NewsList';
import NewsDetail from './android/DemoApp/Screen/Student/NewsDetail';
import Notifications from './android/DemoApp/Screen/Student/Notifications';
import LeaveRequestsTeacher from './android/DemoApp/Screen/Teacher/LeaveRequestsTeacher';
import ClassroomHomeroom from './android/DemoApp/Screen/Teacher/ClassroomHomeroom';
import StudentScores from './android/DemoApp/Screen/Teacher/StudentScores';
import SubjectClasses from './android/DemoApp/Screen/Teacher/SubjectClasses';
import HomeroomClasses from './android/DemoApp/Screen/Teacher/HomeroomClasses';
import StudentList from './android/DemoApp/Screen/Teacher/StudentList';
import StudentDetail from './android/DemoApp/Screen/Teacher/StudentDetail';
import ClassScores from './android/DemoApp/Screen/Teacher/ClassScores';
import ApproveLeaveRequestScreen from './android/DemoApp/Screen/Teacher/ApproveLeaveRequest';
import SubmitLeaveRequestScreen from './android/DemoApp/Screen/Teacher/SubmitLeaveRequest';
import TimetableTeacher from './android/DemoApp/Screen/Teacher/TimetableTeacher';
import ForgotPasswordScreen from './android/DemoApp/Screen/ForgotPasswordScreen';
import VerifyOTPScreen from './android/DemoApp/Screen/VerifyOTPScreen';
import ResetPasswordScreen from './android/DemoApp/Screen/ResetPassword';
// Định nghĩa Stack và Tab
const Stack = createStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator();

function TeacherApp() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ color, size }) => {
          let iconName;

          switch (route.name) {
            case 'Trang Chủ':
              iconName = 'home';
              break;
            case 'Kết Quả Học Tập':
              iconName = 'clipboard';
              break; 
            case 'Cá Nhân':
              iconName = 'calendar';
              break;
            case 'Liên Hệ':
              iconName = 'people';
              break;
            default:
              iconName = 'help-circle';
              break;
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: 'tomato',
        tabBarInactiveTintColor: 'gray',
        tabBarStyle: {
          backgroundColor: '#fff',
          paddingBottom: 5,
          height: 60,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          marginBottom: 5,
        },
      })}
    >
      <Tab.Screen
        name="Trang Chủ"
        component={HomeTeacher}
        options={{ headerShown: false }}
      />
      <Tab.Screen
        name="Kết Quả Học Tập"
        component={ResultTeacher}
      />
      <Tab.Screen
        name="Cá Nhân"
        component={Personal}
      />
      <Tab.Screen
        name="Liên Hệ"
        component={ContactsScreen}
      />
    </Tab.Navigator>
  );
}

function StudentApp() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ color, size }) => {
          let iconName;

          switch (route.name) {
            case 'Trang Chủ':
              iconName = 'home';
              break;
            case 'Kết Quả Học Tập':
              iconName = 'clipboard';
              break;
            case 'Cá Nhân':
              iconName = 'calendar';
              break;
            case 'Liên Hệ':
              iconName = 'people';
              break;
            default:
              iconName = 'help-circle';
              break;
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: 'tomato',
        tabBarInactiveTintColor: 'gray',
        tabBarStyle: {
          backgroundColor: '#fff',
          paddingBottom: 5,
          height: 60,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          marginBottom: 5,
        },
      })}
    >
      <Tab.Screen
        name="Trang Chủ"
        component={HomeStudent}
        options={{ headerShown: false }}
      />
      <Tab.Screen
        name="Kết Quả Học Tập"
        component={ResultStudent}
      />
      <Tab.Screen
        name="Cá Nhân"
        component={Personal}
      />
      <Tab.Screen
        name="Liên Hệ"
        component={ContactsScreen}
      />
    </Tab.Navigator>
  );
}

const App: React.FC = () => {
  return (
    <UserProvider>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Login">
          <Stack.Screen
            name="Login"
            component={LoginScreen}
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="HomeTeacher"
            component={TeacherApp}
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="HomeStudent"
            component={StudentApp}
            options={{ headerShown: false }}
          />
          <Stack.Screen  
            name="Settings" 
            component={Settings} 
          />
          <Stack.Screen  
            name="ChangePassword" 
            component={ChangePassword} 
          />
          <Stack.Screen  
            name="Attendance" 
            component={Attendance} 
          />
          <Stack.Screen  
            name="Personal" 
            component={Personal} 
          />
          <Stack.Screen  
            name="Timetable" 
            component={Timetable} 
          />
          <Stack.Screen  
            name="LeaveRequests" 
            component={LeaveRequests} 
          />
          <Stack.Screen  
            name="Notifications" 
            component={Notifications} 
          />
          <Stack.Screen 
          name="NewsList" 
          component={NewsList} 
          options={{ title: 'Danh Sách Tin Tức' }} 
          />
          <Stack.Screen 
          name="NewsDetail" 
          component={NewsDetail} 
          options={{ title: 'Chi Tiết Tin Tức' }} 
          />
          <Stack.Screen  
            name="LeaveRequestsTeacher" 
            component={LeaveRequestsTeacher} 
          />
          <Stack.Screen  
            name="ClassroomHomeroom" 
            component={ClassroomHomeroom} 
          />
          <Stack.Screen  
            name="StudentScores" 
            component={StudentScores} 
          />
          <Stack.Screen  
            name="SubjectClasses" 
            component={SubjectClasses} 
          />
          <Stack.Screen  
            name="HomeroomClasses" 
            component={HomeroomClasses} 
          />
          <Stack.Screen  
            name="StudentList" 
            component={StudentList} 
          />
          <Stack.Screen  
            name="StudentDetail" 
            component={StudentDetail} 
          />
          <Stack.Screen  
            name="ClassScores" 
            component={ClassScores} 
          />
          <Stack.Screen  
            name="ApproveLeaveRequest" 
            component={ApproveLeaveRequestScreen} 
          />
          <Stack.Screen  
            name="SubmitLeaveRequest" 
            component={SubmitLeaveRequestScreen} 
          />
          <Stack.Screen  
            name="TimetableTeacher" 
            component={TimetableTeacher} 
          />
          <Stack.Screen name="ForgotPasswordScreen" component={ForgotPasswordScreen} />
          <Stack.Screen name="VerifyOTP" component={VerifyOTPScreen} />
          <Stack.Screen 
            name="ResetPassword" 
            component={ResetPasswordScreen} 
          />
        </Stack.Navigator>
      </NavigationContainer>
    </UserProvider>
  );
}

export default App;
