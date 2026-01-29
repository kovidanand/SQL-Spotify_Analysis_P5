# Spotify Streaming Intelligence – Advanced SQL Analytics Project
### Overview

This project applies advanced SQL analytics to Spotify performance data to evaluate artist dominance, track engagement, platform preference, content efficiency, and audio-feature dynamics.

The work focuses on generating decision-grade metrics for content strategy teams, label partners, marketing divisions, and platform growth managers.

Rather than surface-level exploration, the analysis emphasizes comparative performance, behavioral signals, and portfolio optimization.

## Strategic Business Context

**Music streaming platforms compete on:**

- Artist acquisition and retention

- Platform-specific engagement patterns

 - Video vs audio consumption behavior

- Catalog performance concentration

- Audio feature trends that influence virality

- Marketing ROI allocation

This project converts track-level telemetry into strategic insight for monetization, licensing, promotion, and product placement decisions.

## Data Model

The dataset contains artist metadata, album information, musical attributes, audience engagement signals, licensing status, video indicators, 
streaming counts, platform distribution, and derived metrics such as energy-liveness ratios.

## Analytical Coverage and Executive Value
### 1. Tracks Exceeding One Billion Streams
```sql
SELECT 
     track 
FROM spotify 
WHERE
   stream > 1000000000;
```

**Business Impact** 

Identifies elite catalog assets that drive sustained revenue and long-term licensing value.

**Decisions Enabled**                      
• Prioritize premium licensing negotiations                                                  
• Allocate marketing budget to evergreen hits                                 
• Develop anniversary campaigns or remastered releases                                                

### 2. Album-Artist Portfolio Mapping
```sql
SELECT 
    DISTINCT album,
    artist
FROM spotify
ORDER BY 1;
```

**Business Impact**               

Supports catalog ownership audits and portfolio segmentation by artist.

**Decisions Enabled**                                          
• Identify concentration risk                                                              
• Guide acquisition diversification                                                          
• Support royalty reconciliation                                                     


### 3. Licensed Track Comment Volume
```sql
SELECT 
    COUNT(Comments)
FROM spotify 
WHERE 
   licensed = 'TRUE';
```

**Business Impact**

Measures engagement intensity on licensed content.

**Decisions Enabled**                                 
• Validate licensing ROI                                                                                          
• Inform renegotiation strategies                                                
• Prioritize partnership extensions                               

### 4. Single-Release Performance
```sql
SELECT 
    track
FROM spotify 
WHERE 
  Album_type = 'single';
```


**Business Impact**

Isolates single-driven growth strategies.

**Decisions Enabled**                                                            
• Optimize single-first release cycles                                                 
• Evaluate teaser-track marketing tactics                                                               

### 5. Album-Level Danceability Trends
```sql
SELECT 
     album,
     AVG(danceability)
FROM spotify
GROUP BY 1
ORDER by 2 DESC;
```

**Business Impact**

Connects musical attributes to audience appeal.

**Decisions Enabled**                                                                  
• Inform playlist curation logic                                                    
• Support audio-feature-based recommendations                                                            
• Guide production decisions                                                               


### 6. Official Video Engagement
```sql
SELECT 
    track,
    SUM(views) AS Total_views,
    SUM(likes) AS Total_likes
FROM spotify 
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC;
```

**Business Impact**

Measures cross-media amplification through video.

**Decisions Enabled**                                                  
• Invest in video production                                                     
• Promote audiovisual releases                               
• Prioritize YouTube-Spotify synergy                                               

### 7. Spotify vs YouTube Dominance
```sql
SELECT * FROM
(SELECT 
    track,
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_spotify,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_youtube
FROM spotify
GROUP BY 1
) AS T1
WHERE 
    streamed_on_spotify > streamed_on_youtube
    AND 
	streamed_on_youtube <> 0;
```

**Business Impact**

Identifies platform-specific audience preference.

**Decisions Enabled**                                                                         
• Customize marketing channels                                                          
• Allocate ad spend by platform                                                            
• Optimize release timing    


### 8. Above-Average Liveness Tracks
```sql
SELECT
    track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

**Business Impact** 

Signals strong live-performance energy correlated with audience response.

**Decisions Enabled**                                             
• Prioritize concert tours                                          
• Push live versions                                                
• Festival programming                                                 


### 9. Cumulative Likes vs Views
```sql
SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (
        ORDER BY views
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM spotify
ORDER BY 2 DESC;
```

**Business Impact**

Evaluates engagement concentration across the catalog.

**Decisions Enabled**                                           
• Identify dependency on blockbuster hits                                           
• Diversify promotion                                                 
• Manage risk exposure                                                               

## Business Value Delivered                               

• Identifies high-ROI artists and tracks                                                             
• Supports platform-specific growth strategies                                                             
• Guides video investment decisions                                                                    
• Strengthens licensing negotiations                                           
• Improves marketing allocation                                                
• Enables catalog portfolio optimization
                                        























