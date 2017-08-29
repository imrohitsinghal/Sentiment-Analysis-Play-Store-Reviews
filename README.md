## Google-Play-Store-Reviews

## About:
A small utility to generate useful data from reviews/feedback customers provide on Google Play Store. Helps you to focus on areas to improve in the app.

 - It gets Latest Feedback from Google Play for specified Android App
 - Stores all the reviews into a CSV file(latest_reviews)
 - Can be utilized to see what functionalities are appreciated by customers

## Analytics:
 - Extract all negative and neutral reviews
 - Extract out App features and functionalities that are impacted or affected
 - Stores all negative and neutral reviews in a file(negative_reviews)

## Output:
- Generates a sorted HTML(Result.html) file which contains Impacted Area and Review
- All the negative reviews are stored in a CSV file


## How to Run:
1. Fetch all the latest reviews about the app</br>
  `rake PACKAGE_NAME=<"Enter app package name"> reviews:fetch`

2. Analyze and separate all negative and neutral reviews</br>
  `rake reviews:analyze`

3. Generate a HTML file</br>
  `rake reviews:output`


## What's Next:
- Making this utility to run on various feedback/review sources like twitter, Facebook etc
