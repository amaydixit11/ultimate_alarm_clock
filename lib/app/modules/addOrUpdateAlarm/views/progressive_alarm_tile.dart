import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ProgressiveAlarmTile extends StatelessWidget {
  const ProgressiveAlarmTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    int intervalMinutes;
    int startBeforeMinutes;
    bool isProgressiveEnabled;

    return Obx(
      () => ListTile(
        title: Row(
          children: [
            Flexible(
              child: Text(
                'Progressive Alarms'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: themeController.primaryTextColor.value.withOpacity(0.3),
              ),
              onPressed: () {
                Utils.showModal(
                  context: context,
                  title: 'Progressive Alarms'.tr,
                  description:
                      'Multiple alarms that ring at specified intervals before your final wake-up time to help you wake up gradually.',
                  iconData: Icons.alarm,
                  isLightMode:
                      themeController.currentTheme.value == ThemeMode.light,
                );
              },
            ),
          ],
        ),
        onTap: () {
          Utils.hapticFeedback();
          // Store initial values
          intervalMinutes = controller.progressiveInterval.value;
          startBeforeMinutes = controller.progressiveStartBefore.value;
          isProgressiveEnabled = controller.isProgressiveEnabled.value;

          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: themeController.secondaryBackgroundColor.value,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Progressive Alarms Settings'.tr,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Enable/Disable Switch
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Enable Progressive Alarms'.tr,
                                  style: TextStyle(
                                    color:
                                        themeController.primaryTextColor.value,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: controller.isProgressiveEnabled.value,
                                activeColor: ksecondaryColor,
                                onChanged: (value) {
                                  controller.isProgressiveEnabled.value = value;
                                  if (!value) {
                                    controller.progressiveStartBefore.value = 0;
                                  } else {
                                    controller.progressiveStartBefore.value =
                                        30;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Settings Container
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: themeController.primaryBackgroundColor.value,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Start Before Setting
                              _buildSettingSection(
                                context: context,
                                title: 'Start Before Final Alarm'.tr,
                                child: NumberPicker(
                                  value:
                                      controller.progressiveStartBefore.value,
                                  minValue: 5,
                                  maxValue: 180,
                                  step: 5,
                                  haptics: true,
                                  textStyle: TextStyle(
                                    color: themeController
                                        .primaryTextColor.value
                                        .withOpacity(0.5),
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color: controller.isProgressiveEnabled.value
                                        ? themeController.primaryTextColor.value
                                        : themeController.primaryTextColor.value
                                            .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  onChanged: (value) {
                                    Utils.hapticFeedback();
                                    controller.progressiveStartBefore.value =
                                        value;
                                  },
                                ),
                                suffix: 'minutes'.tr,
                                enabled: controller.isProgressiveEnabled.value,
                              ),

                              const Divider(height: 32),

                              // Interval Setting
                              _buildSettingSection(
                                context: context,
                                title: 'Interval Between Alarms'.tr,
                                child: NumberPicker(
                                  value: controller.progressiveInterval.value,
                                  minValue: 1,
                                  maxValue: 60,
                                  step: 1,
                                  haptics: true,
                                  textStyle: TextStyle(
                                    color: themeController
                                        .primaryTextColor.value
                                        .withOpacity(0.5),
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color: controller.isProgressiveEnabled.value
                                        ? themeController.primaryTextColor.value
                                        : themeController.primaryTextColor.value
                                            .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  onChanged: (value) {
                                    Utils.hapticFeedback();
                                    controller.progressiveInterval.value =
                                        value;
                                  },
                                ),
                                suffix: 'minutes'.tr,
                                enabled: controller.isProgressiveEnabled.value,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Preview Text
                        if (controller.isProgressiveEnabled.value &&
                            controller.progressiveStartBefore.value > 0)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Alarms will ring every ${controller.progressiveInterval.value} minutes, starting ${controller.progressiveStartBefore.value} minutes before your final alarm.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: themeController.primaryTextColor.value
                                    .withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Done Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Utils.calculateProgressiveAlarmTimes(
                                intervalMinutes,
                                startBeforeMinutes,
                                true,
                                controller.selectedTime.value,
                              );
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Done'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: themeController
                                        .secondaryTextColor.value,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  controller.isProgressiveEnabled.value
                      ? '${controller.progressiveStartBefore.value}min, ${controller.progressiveInterval.value}min'
                      : 'Off'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: controller.isProgressiveEnabled.value
                            ? themeController.primaryTextColor.value
                            : themeController.primaryDisabledTextColor.value,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required BuildContext context,
    required String title,
    required Widget child,
    required String suffix,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: enabled
                ? themeController.primaryTextColor.value
                : themeController.primaryTextColor.value.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: child),
            const SizedBox(width: 8),
            Text(
              suffix,
              style: TextStyle(
                color: enabled
                    ? themeController.primaryTextColor.value
                    : themeController.primaryTextColor.value.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _presetToInitial(
      int intervalMinutes, int startBeforeMinutes, bool isProgressiveEnabled) {
    controller.progressiveInterval.value = intervalMinutes;
    controller.progressiveStartBefore.value = startBeforeMinutes;
    controller.isProgressiveEnabled.value = isProgressiveEnabled;
  }
}
