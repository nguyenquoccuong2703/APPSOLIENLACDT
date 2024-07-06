export interface Student {
    StudentId: number;
    UserId: number;
    Name: string;
    DateOfBirth: string;
    ClassId: number;
    SDTPH: string;
    id: string;
}
export interface Class {
    ClassId: number;
    ClassName: string;
    AcademicYear: number;
    GradeId: number;
}
export type RootStackParamList = {
    Login: undefined;
    HomeTeacher: undefined;
    HomeStudent: undefined;
    ThoiKhoaBieuTeacher: undefined;
    Settings: undefined;
    ChangePassword: undefined;
    Attendance: undefined;
    Personal: undefined;
    Timetable: undefined;
    Notifications: undefined;
    LeaveRequests: undefined;
    NewsList: undefined;
    NewsDetail: { newsId: number };
    LeaveRequestsTeacher: undefined;
    ClassroomHomeroom: { years: string[] };
    StudentScores: { studentId: number };
    SubjectClasses: { subjectClasses: Class[] };
    HomeroomClasses: { year: string };
    StudentList: { classId: number };
    StudentDetail: { studentId: number };
    ClassScores: { classId: number };
    SubmitLeaveRequest: undefined;
    ApproveLeaveRequest: undefined;
    TimetableTeacher: undefined;
    ForgotPasswordScreen: undefined;
    VerifyOTP: { username: string; email: string; otp: string }; // Thêm VerifyOTP với đúng kiểu
    ResetPassword: { email: string; username: string };
    NotificationsTeacher: undefined;
    NotificationInput: { studentId: number | null; classId: number | null };
    NotificationInput2:{ userId: string };
};
