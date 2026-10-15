class AppConstants {
  static const List<String> departments = [
    'Computer Science',
    'Business Administration',
    'Electrical Engineering',
    'Mathematics',
    'Physics',
    'English',
  ];

  static const Map<String, List<String>> departmentFields = {
    'Computer Science': [
      'Software Engineering',
      'Computer Engineering',
      'Artificial Intelligence',
      'Information Technology',
      'Data Science',
      'Cyber Security',
      'Management Information Systems',
    ],
    'Business Administration': [
      'Accounting',
      'Finance',
      'Marketing',
      'Human Resource Management',
      'Management',
      'Entrepreneurship',
    ],
    'Electrical Engineering': [
      'Power Systems',
      'Electronics',
      'Telecommunications',
      'Control Systems',
      'Renewable Energy',
    ],
    'Mathematics': [
      'Pure Mathematics',
      'Applied Mathematics',
      'Statistics',
      'Actuarial Science',
    ],
    'Physics': [
      'Theoretical Physics',
      'Applied Physics',
      'Nuclear Physics',
      'Astrophysics',
    ],
    'English': [
      'Literature',
      'Linguistics',
      'Creative Writing',
      'Applied Linguistics',
    ],
  };

  static List<String> fieldsForDepartment(String? department) {
    if (department == null) return [];
    return departmentFields[department] ?? [];
  }

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> sections = [
    'A',
    'B',
    'C',
    'D',
  ];

  static const List<String> semesters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];
}
