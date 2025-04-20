# GithubList

This app uses Github pubic APIs.
The app has user listing screen where one can view the Github users, apply filter by name or sort them in ascending or descending order by login. When we select a user, we go to the detail screen where we can see a repository list with description created by the selected user. On selecting a repository we can see the web view where the repository is displayed in github.

Pods used: Alamofire, AlamofireImage
Encryption used for storing access token

Known issue: after 2 hits to the user search API, API gives 403 error.
So we do not get to see much of pagination.
https://github.com/changesets/action/issues/192
