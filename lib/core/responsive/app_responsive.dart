abstract class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

bool isMobile(double width) => width < AppBreakpoints.mobile;
bool isTablet(double width) =>
    width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;
bool isDesktop(double width) => width >= AppBreakpoints.tablet;
