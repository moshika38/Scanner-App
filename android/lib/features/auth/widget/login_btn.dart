import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';

class LoginBtn extends StatelessWidget {
  final VoidCallback signInWithGoogle;
  const LoginBtn({
    super.key,
    required this.signInWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: signInWithGoogle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://cdn-icons-png.freepik.com/256/13170/13170545.png?uid=R135322611&ga=GA1.1.508168484.1736677221&semt=ais_hybrid',
              height: 24,
            ),
            const SizedBox(width: 15),
            Text(
              'Sign in with Google',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
