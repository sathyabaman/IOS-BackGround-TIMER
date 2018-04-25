# IOS-BackGround-TIMER

How the time is still being active, when the app is in background?


I used Apps Lifecycle Method Such as 

UIApplicationDidEnterBackground

UIApplicationWillEnterForeground  To overcome this issue. Using broadcast receiver such as NotificationCenter am controlling the app’s lifecycle in view controller.


 UIApplicationDidEnterBackground
 
-	When the app goes to the background, I am saving the current time in the timer to user Defaults

 UIApplicationWillEnterForeground

-	Immediately when the app comes to foreground, I am taking the saved time from user Defaults and getting the time difference
