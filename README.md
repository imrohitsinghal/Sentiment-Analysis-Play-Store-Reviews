## Sentiment-Analyser

## About:
A utility to generate useful data from reviews/feedback customers/users provide on Google Play Store. Helps you to focus on areas which needs improvement in the application.

 - It fetches Per Day/Newest Feedback from Play Store for specified Android App
 - Stores all the customer feedback into a CSV file(latest_reviews)
 - Gives you a report mentioning areas to improve with the feedbacks
 - Can be utilized to see what functionalities are appreciated by customers

## Sentiment Analysis:
 - Extract all negative and neutral reviews by customers
 - Extract out App features/areas and functionalities that are impacted or affected
 - Stores all negative and neutral reviews in a file (negative_reviews.csv)

## Output:
- Generates a sorted HTML (review_report.html) file which contains Impacted Area and Reviews related to each area/functionality
![Screenshot](Report_28thNov.png)
- All the negative and newest reviews are stored in a CSV files

## Pre-requisite:
- Generate your APP_ID AND APP_KEY from AYLIEN for accessing the API ans put it under fetch_analyse.rake

## How to Run:
1. a. Apply Analytics on daily newest reviews about your app
   `rake PACKAGE_NAME=<APK_PACKAGE_NAME> REVIEW_DATE=6  reviews:run:all`
    - `rake PACKAGE_NAME=com.vuclip.viu REVIEW_DATE=6  reviews:run:all`
   
   b. Generate a report for Areas/Functionality to Improve
    `rake PACKAGE_NAME=<APK_PACKAGE_NAME> REVIEW_DATE=6  reviews:run:output`
    
2. Fetch daily newest reviews about your app</br>
  `rake PACKAGE_NAME=<"Enter app package name"> REVIEW_DATE=<Day> reviews:fetch`
   - `rake PACKAGE_NAME=com.vuclip.viu REVIEW_DATE=6  reviews:fetch`
   
3. For Sentiment Analysis without any API of reviews/feedback
    `rake PACKAGE_NAME=com.vuclip.viu REVIEW_DATE=6  reviews:run:process`

## What's Next:
- Making this utility to run on various feedback/review sources like twitter, Facebook etc
