import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../blocs/user/user_bloc.dart';
import '../models/user.dart';
import 'user_detail_screen.dart';
import 'add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = 2;
        if (screenWidth > 1200) {
          crossAxisCount = 5;
        } else if (screenWidth > 800) {
          crossAxisCount = 3;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'User List',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary, fontSize: 20.sp),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            actions: [
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: widget.toggleTheme,
                activeColor: Theme.of(context).colorScheme.onPrimary,
              ),
              IconButton(
                icon: Icon(Icons.person_add, color: Theme.of(context).colorScheme.onPrimary, size: 24.sp),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AddUserScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoadSuccess) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.8,
                  ),
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                UserDetailScreen(user: user),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Hero(
                                  tag: 'user_avatar_${user.id}',
                                  child: CircleAvatar(
                                    radius: 40.r,
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    child: Text(
                                      user.name.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.h),
                              
                            
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is UserLoadFailure) {
                return Center(child: Text('Failed to load users: ${state.error}', style: TextStyle(fontSize: 16.sp)));
              }
              return Center(child: Text('No users found.', style: TextStyle(fontSize: 16.sp)));
            },
          ),
        );
      },
    );
  }
}

