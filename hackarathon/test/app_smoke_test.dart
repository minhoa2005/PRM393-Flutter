import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/main.dart';

void main() {
  testWidgets('app starts on the login page', (tester) async {
    await tester.pumpWidget(const StudentTaskManagerApp());

    expect(find.text('Student Task Manager App'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
