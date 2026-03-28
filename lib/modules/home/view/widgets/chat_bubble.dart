import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../data/models/chat_message_model.dart';
import '../../../../data/services/auth_service.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessageModel message;
  final bool isNew;

  const ChatBubble({
    super.key,
    required this.message,
    this.isNew = false,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingXS,
          ),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // AI avatar — SVG logo mark in primaryLight circle
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/logo.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            AppSizes.bubbleMaxWidth,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.bubblePaddingH,
                        vertical: AppSizes.bubblePaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.userBubble
                            : isDark
                                ? AppColors.darkAiBubble
                                : AppColors.aiBubble,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                              AppSizes.radiusBubble),
                          topRight: const Radius.circular(
                              AppSizes.radiusBubble),
                          bottomLeft: Radius.circular(
                              isUser ? AppSizes.radiusBubble : 4),
                          bottomRight: Radius.circular(
                              isUser ? 4 : AppSizes.radiusBubble),
                        ),
                      ),
                      child: widget.message.type == 'image' &&
                              widget.message.imageUrl != null
                          ? _ImageMessageContent(
                              path: widget.message.imageUrl!,
                              isUser: isUser,
                              caption: _deriveImageCaption(
                                  widget.message.content),
                            )
                          : SelectableText(
                              widget.message.content,
                              style: GoogleFonts.inter(
                                color: isUser
                                    ? Colors.white
                                    : isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                                fontSize: AppSizes.bodyMedium,
                                height: 1.5,
                              ),
                            ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      Formatters.formatChatTime(widget.message.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // User avatar — initials in primary circle
              if (isUser) ...[
                const SizedBox(width: 8),
                _UserAvatar(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _deriveImageCaption(String content) {
  final lower = content.toLowerCase();
  if (lower.contains('chest') || lower.contains('x-ray') || lower.contains('xray')) {
    return 'Chest X-ray image attached';
  } else if (lower.contains('skin') || lower.contains('lesion')) {
    return 'Skin lesion image attached';
  }
  return 'Medical image attached';
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String initials = 'U';
    try {
      initials = Get.find<AuthService>().currentUser.value.initials;
    } catch (_) {}
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ImageMessageContent extends StatelessWidget {
  final String path;
  final bool isUser;
  final String caption;
  const _ImageMessageContent({
    required this.path,
    required this.isUser,
    this.caption = 'Image attached',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(path),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 200,
              height: 120,
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined,
                    size: 36, color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          caption,
          style: GoogleFonts.inter(
            fontSize: AppSizes.bodySmall,
            color: isUser ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
