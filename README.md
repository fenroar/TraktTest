Sample project that makes use Trakt and TMDB API to grab a list of trending movies and displays them in a table. Can drill down to then see details about that particular movie.

Trakt.tv API doesn't include images which meant I needed to integrate TMDB API to grab images for the movies. Also had to a lot of refactoring of the API service as Trakt includes a lot of optional values you can append to requests to include more or less information about a model and pagination.

This sample project uses Alamofire and ObjectMapper. 
