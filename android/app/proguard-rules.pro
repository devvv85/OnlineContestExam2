-keepattributes *Annotation*
-dontwarn com.razorpay.**
#noinspection ShrinkerUnresolvedReference
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}