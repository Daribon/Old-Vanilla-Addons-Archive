CensusPlus - by Rollie of Bloodscalp aka Cooper Sellers

  WEBSITE

   http://www.warcraftrealms.com/

  VERSION
  
    2.0 - 4/23/2005 - Update
        -Friends panel will no longer even attempt to open if the auto-close who is selected.  This 
            allows any other panels to be open during a census and they will not close or change your
            view.
        -Mini-Census button is now moveable.  You'll have to click just around the button to move it
        -Added PVP Honor tracking.  This will be viewable on the site soon.
        -Modified the time tracking, cool new stats on the site to follow soon.
        -Added in some regional server detection.  Please note if you get any error messages detailing
            that the Mod thinks your locale should be set differently and let me know about them.
        -Auto-census will no longer start as soon as you log in and will instead wait 5 minutes.

    1.8 - 3/23/2005 - Update
        -Silenced the Friends panel clicking when opening and closing during a census
        -Implemented the new time() and date() APIs
        -Removed /censusdate
        -Added option to take auto-census
        -Added option window

   1.4 - 2/4/2005 - French and German localization
   1.3 -            - Small bug fix for error in 1.2
   
   1.2 - 1/19/2005 - Update
        -Fixed a bug with a current census that is paused becoming unpaused when you close certain windows. 
        -Added a /censusverbose command that will toggle the CensusPlus messages on/off. 
        -Modified the way a census is taken. Instead of the divide and conquer style used that started a census 
            with 1-60 and going from there, it will now start in 5 level increments and divide if necessary. 
        -Added guild support. The mod will now capture guild data when viewed on the guild panel. This data 
            is used to provide more comprehensive data on the site and is available through the guild exports. 
        -Added a tracking feature that will allow tracking of the number of characters seen during a census. 
            This data is displayed on the Activity Page 
   
   1.0 - 1/10/2005

  INTRODUCTION

    CensusPlus came about due to requested changes and desired options
    not present in the original Census UI Mod by Ian Pieragostini.
    
    I spoke with Ian and he has lost interest in World of Warcraft modding
    and encouraged me to modify the Census Mod to my liking.  Thus I
    have done so.
    
    The original Census UI Mod basically took snapshots of your current
    realm and faction.  You could keep this data and combine it with 
    other snapshots to provide greater statistical analysis.
    
    CensusPlus offers many features above and beyond what the original Census
    UI mod provided.  Here follows a list of added features:
    
        -  Abilty to minimize the main census window
            which provides you the abilty to actually play while a census
            is being taken
        -  Ability for the Friends panel not to be shown after
            each /who is sent to the server.  This keeps the UI open from 
            the main Census window
        -  Ability to pause and unpause the current census
        -  Ability to stop the current census in progress
        -  Added a date information which allows the user to place a
            date timestamp on all characters that are found during census's
            taken that day --  This helps facilitate greater accuracy in 
            results when census data is uploaded to www.warcraftrealms.com
        -  Data on number of characters seen during the census snapshot.
        -  Collection of Honor points data.

  USAGE
  
    Unzip the files into your %World of Warcraft/Interface/AddOns directory.  It
    should create a CensusPlus directory with the installed files.
    
    If you have Cosmos installed, CensusPlus will register itself with Cosmos
    and you can invoke the Census window by selecting the CensusPlus option from
    the Census menu.
    
    You can also invoke the CensusPlus window by typing /censusplus or /census+
    
    You can select to not open the Friends panel when a /who is sent.
    
    You can select to automatically display the Mini-Census button which must be
    visible in order for a Census to be taken while the main Census window is 
    minimized.
    
    By selecting the Take button from the main census panel, you will initiate a
    Census snapshot.  Depending on the population of your realm and faction, this could 
    take several minutes.
    
    Clicking the Purge button will purge all your collected data from your local Census
    database.
    
    Clicking the Stop button will stop the current census if one is in progress.
    
    Clicking the Pause button will pause the current census if one is in progress.
    
    If you so choose, you can upload your collected census information to 
    http://www.warcraftrealms.com    Doing so will greatly help in the tracking
    of your realm and faction's population numbers and statistics.
      
    
    


