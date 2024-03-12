Config = {}

Config.KonvojusLocation = vector3(-137.7947, -29.7831, 58.0634) -- Heist car spawn
Config.KonvojusHeading = 346.3817 
Config.KonvojusLocationXYZ = { x= -137.7947, y= -29.7831, z= 58.0634 } -- Heist car spawn

Config.EndJobLocation = vec3(-509.2665, 4369.0303, 66.5243) -- Match this one and the one below.
Config.EndLocation = { x= -509.2665, y= 4369.0303, z= 67.5241 }
Config.EndJobPedHeading = 181.6827

Config.StartJobPedModel = 'u_m_y_staggrm_01'
Config.StartJobLocation = vec3(-146.9035, -26.3093, 57.0779) 
Config.StartJobPedHeading = 258.8474
Config.StartJobRadius = 50

Config.PoliceRequired = 0
Config.PoliceJob = 'police'

Config.JobNames = { -- Jobs that are allowed to start the Convoy
    'gang1',
    'gang2'
}

Config.CDDispatch = true

Config.Car = 'hauler2'

Config.RewardItem = 'money'
Config.RewardAmount = 50000

Config.Language = {
    notifytitle ='Convoy',
    alreadyhavecar ='You already got a convoy!',
    notifyicon = 'route',
    nogangjob ='You do not have the required job!',
    nopolicejob = 'Not enough police!',
    targetnpc ='Convoy',
    menutitle = 'Convoy Menu',
    menustarttitle = 'Start the Convoy!',
    menustartdesc = 'Press to start the Convoy.',
    jobdone = 'You finished!',
    wrongcarinproximity ='Wrong vehicle is closest to the NPC!',
    notstartedjob ='You have not started the Convoy!',
    cddispatchtitle = '10-51 - Convoy',
    cdsomeonefinishedmission = 'Someone finished the Convoy..',
    cdtext = '112 - Convoy',
    cdstartmission = 'Someone started the convoy...',
    waittalking = 'Wait until you are finished talking about the plan!',
    gowaypoint = 'Drive to the waypoint!'
}
