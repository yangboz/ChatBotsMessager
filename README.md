ChatBotsMessager
================

With Emotional Artificial Intelligence Chat Bots Chatting!

AppStore
================
https://itunes.apple.com/us/app/aichatbot/id879922550?l=zh&ls=1&mt=8

![Screenshot of master view](https://raw.github.com/yangboz/ChatBotsMessager/master/ChatBotsMessager/ChatBotsMessager/Snapshots/ChatBotsMessagerMaster.jpg)
![Screenshot of detail view](https://raw.github.com/yangboz/ChatBotsMessager/master/ChatBotsMessager/ChatBotsMessager/Snapshots/ChatBotsMessagerDetail.jpg)

API
================
http://www.personalityforge.com/bookofapi.php


Emoticons
================

http://messenger.yahoo.com/features/emoticons/


Hash-based message authentication code
================

TODO:

#1.Crash fix up by using tableview chat components;

#2.API key/secret prereference provider solution;

http://en.wikipedia.org/wiki/HMAC


hash_hmac
================

https://gist.github.com/yangboz/77fffef6b6d4fe16b144

Raw response string
================
<br><br>Correct parameters and objects received<br>raw message: {"message":{"message":"New","timestamp":1364048112,"chatBotID":6},"user":{"gender":"m","lastName":"Sufani","firstName":"Tugger","externalID":"abc-639184572"}}<br>apiSecret: XXXXXYYYYYYZZZZZ<br>Do the following two match?<br>f64a537885513777ccb620a54530f700ebc9020adc5c19b326bff2f58598cfd9<br>f64a537885513777ccb620a54530f700ebc9020adc5c19b326bff2f58598cfd9<br>CORRECT MATCH!<pre>Array
(
    [message] => Array
        (
            [message] => New
            [timestamp] => 1364048112
            [chatBotID] => 6
        )

    [user] => Array
        (
            [gender] => m
            [lastName] => Sufani
            [firstName] => Tugger
            [externalID] => abc-639184572
        )

)
</pre>sent on Sat, 23 Mar 2013 10:15:12 am<br>1 seconds ago. (limit is 300)<br>{"success":1,"errorMessage":"","

TODO List
================

1.Preference implementation;(TBC)

2.Emotional presentation;(normal, happy, angry, averse, sad, evil, fuming, hurt, surprised, insulted, confused, amused, asking)

3.Icon assets file; (Done!including app lanuch images);

4.Testing and bug-issues fixing; (More on chat view)

5.Submit to Apple AppStore and inform Benji; (Done)

....


Backlog
================

http://www.codeproject.com/Articles/689451/Developing-Android-Applications-with-Voice-Recogni
