import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// ---------------------------------------------------------------------------
/// CONFIG: edit these values
/// ---------------------------------------------------------------------------
const String kDeveloperName = 'Jayanshu Bhardwaj';
const String kAppName = 'Node';
const String kAppTagline = 'Connecting the community';
const String kContactEmail = 'jayanshub18@gmail.com'; // <-- put your mail here

class SocialLink {
  final String label;
  final String url;
  final IconData icon; // demo icon (used when assetPath is null)
  final String? assetPath; // e.g. 'assets/icons/github.png'

  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
    this.assetPath,
  });
}

// Replace the URLs with your real profiles.
// To use your own PNGs, set assetPath, e.g. assetPath: 'assets/icons/github.png'
List<SocialLink> kSocialLinks = [
  SocialLink(
    label: 'GitHub',
    url: 'https://github.com/jb-git-code',
    icon: LucideIcons.separatorVertical,
    assetPath: 'assets/logos/github.png',
  ),
  SocialLink(
    label: 'Instagram',
    url: 'https://www.instagram.com/jayanshub18/',
    icon: LucideIcons.separatorVertical,
    assetPath: 'assets/logos/instagram.png',
  ),
  SocialLink(
    label: 'X',
    url: 'https://x.com/JayanshuBh38322',
    icon: LucideIcons.separatorVertical, // demo icon, swap with an X png later
    assetPath: 'assets/logos/x.png',
  ),
  SocialLink(
    label: 'LinkedIn',
    url: 'https://www.linkedin.com/in/jayanshu-bhardwaj-05a791322/',
    icon: LucideIcons.separatorVertical,
    assetPath: 'assets/logos/linkedin.png',
  ),
];

/// ---------------------------------------------------------------------------
/// SCREEN
/// ---------------------------------------------------------------------------
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link')));
    }
  }

  Future<void> _sendEnquiry(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: kContactEmail,
      queryParameters: {'subject': 'Enquiry about $kAppName'},
    );
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No email app found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // const SizedBox(height: 16),

              // App identity
              Lottie.asset(
                'assets/animations/node_connect.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              // const SizedBox(height: 16),
              Text(
                kAppName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                kAppTagline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 20),

              // Developer card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'THE DEVELOPER',
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      kDeveloperName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Social icons
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        for (final link in kSocialLinks)
                          _SocialButton(
                            link: link,
                            onTap: () => _openUrl(context, link.url),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Enquiry button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () => _sendEnquiry(context),
                  icon: const Icon(LucideIcons.mail, size: 20),
                  label: const Text(
                    'Enquiry',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final SocialLink link;
  final VoidCallback onTap;

  const _SocialButton({required this.link, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: link.label,
      child: Material(
        color: scheme.primary.withValues(alpha: 0.1),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: link.assetPath != null
                  // Your own PNG
                  ? Image.asset(
                      link.assetPath!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    )
                  // Demo icon
                  : Icon(link.icon, size: 24, color: scheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
