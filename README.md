# Fanxange
    [] Google Pay Intent
        04-06 01:52:18.988  1652  4143 W XSpaceManagerServiceImpl: checkXSpaceControl, from:com.miui.gallery, to:com.google.android.apps.nbu.paisa.user, with act:android.intent.action.SEND, callingUserId:0, toUserId:0
        04-06 01:52:18.990  1652  4143 I ActivityTaskManager: START u0 {act=android.intent.action.SEND typ=image/* flg=0x18080001 cmp=com.google.android.apps.nbu.paisa.user/com.google.nbu.paisa.flutter.gpay.app.ShareIntentFilter clip={image/* {U(content)}} (has extras)} from uid 10112 from pid 24235 callingPackage com.miui.gallery

    [] Paytm Intent
        http://m.paytm.me/scpn
        
# Feature 
    [*] Order Flow
        [*] Order creation
        [*] Store the order in orderbook
    [*] Player Segregation Flow
        [*] Get the Match Data
        [*] Get the player info
        [*] Get the Player points
    [*] Order optimizations 
        [*] Create the order under 1sec
        [*] filled the order if buy and sell quantity is there
        [*] disable the player if the out of stock
    [*] Wallet
        [*] Design UI
        [*] Show the balance
        [*] Deposit 
        [*] Withdraw
        [*] Show the transactions
    [*] Portfolio
        [*] Design the UI
        [*] Sort according the matches
        [*] Sort according the players
        [*] Show the orders
        [*] Show No Orders present
    [*] Create the Points system page
    [*] Show the Points for each player
    [*] Show the Detailed Points for the Player for specific match
    [*] Show the multiple orders for each player 
    [] Profile
        [] Made the UI Page
        [] Update the required filed
        [] Implement the logout
        [] Implement the verification
        [] Implement the google auth
        [] Implement the kyc verification
    [] Forget Password
    [] Notification
    [] Add the net profit in the wallet

    
#   Bug
    [] Login Bug => After register when user login not work
    
    [*] Sort the matches
    [*] Register Bug => not navigating to Homepage
    [*] Show the player stats screen in completed and live matches
    [*] Throw error when order balance is not there
    [*] When login getting the exception regarding the matches and wallet
    [*] When creating the order portfolio not updating
    [*] Loading not implemented in points page
    [*] Loading not implemented in the orders page
    [*] Wallet Bug => int not able to convert into double
    [*] Remove the padding from the wallet container
