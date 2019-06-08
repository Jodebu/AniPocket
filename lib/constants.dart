//App title
const String APP_TITLE = 'AniPocket';

//Api related
const String AIRED = 'aired';
const String ANIME = 'anime';
const String DURATION = 'duration';
const String EPISODE_ID = 'episode_id';
const String EPISODES = 'episodes';
const String EPISODES_LAST_PAGE = 'episodes_last_page';
const String ERROR = 'error';
const String FILLER = 'filler';
const String GENRE = 'genre';
const String GENRES = 'genres';
const String ID = 'id';
const String IMAGE_URL = 'image_url';
const String INDEX = 'index';
const String LARGE = 'large';
const String MAL_ID = 'mal_id';
const String MANGA = 'manga';
const String NAME = 'name';
const String PICTURES = 'pictures';
const String PROMO = 'promo';
const String RATING = 'rating';
const String RESULTS = 'results';
const String RECAP = 'recap';
const String SMALL = 'small';
const String STATE = 'state';
const String STATUS = 'status';
const String STRING = 'string';
const String SYNOPSIS = 'synopsis';
const String TITLE = 'title';
const String TITLE_ENGLISH = 'title_english';
const String TITLE_JAPANESE = 'title_japanese';
const String TITLE_ROMANJI = 'title_romanji';
const String TRAILER_URL = 'trailer_url';
const String TYPE = 'type';
const String TOP = 'top';
const String VIDEO_URL = 'video_url';
const String VIDEOS = 'videos';
const String VIEW_TYPE = 'view_type';

//UI related
const String UI_ADVANCED_SEARCH = 'Advanced search';
const String UI_AIRING = 'Airing';
const String UI_TOP_ANIME = 'Top anime';
const String UI_CHARACTERS = 'Characters';
const String UI_GENRES = 'Genres';
const String UI_LOADING = 'Loading...';
const String UI_ENGLISH = 'English:';
const String UI_EPISODES = 'Episodes';
const String UI_FAVORITES = 'Favorites';
const String UI_FILTER = 'Filter';
const String UI_NEWS = 'News';
const String UI_INFO = 'Info';
const String UI_JAPANESE = 'Japanese:';
const String UI_NO_DATE = 'No date found';
const String UI_NO_EPISODES = 'This is a film/special/OVA\nIt only has one episode';
const String UI_NO_NEWS = 'No news were found for this anime';
const String UI_NO_TITLE = 'No title found';
const String UI_MEDIA = 'Media';
const String UI_PLAY_IN_YOUTUBE = 'Play in YouTube';
const String UI_SEARCH = 'Search';
const String UI_SEARCH_HINT = 'Search Anime';
const String UI_STANDARD_TITLE = 'Standard title:';
const String UI_STATE = 'State';
const String UI_SYNOPSIS = 'Synopsis';
const String UI_TYPE = 'Type';
const String UI_VIDEOS = 'Videos';

//SharedPreferences related
const String SP_FAVORITES = 'favorites';

//Genre related
const List<Map> ANIME_GENRES = [
  {MAL_ID: 1, NAME: 'Action'},
  {MAL_ID: 2, NAME: 'Adventure'},
  {MAL_ID: 3, NAME: 'Cars'},
  {MAL_ID: 4, NAME: 'Comedy'},
  {MAL_ID: 5, NAME: 'Dementia'},
  {MAL_ID: 6, NAME: 'Demons'},
  {MAL_ID: 7, NAME: 'Mystery'},
  {MAL_ID: 8, NAME: 'Drama'},
  {MAL_ID: 9, NAME: 'Ecchi'},
  {MAL_ID: 10, NAME: 'Fantasy'},
  {MAL_ID: 11, NAME: 'Game'},
  {MAL_ID: 12, NAME: 'Hentai'},
  {MAL_ID: 13, NAME: 'Historical'},
  {MAL_ID: 14, NAME: 'Horror'},
  {MAL_ID: 15, NAME: 'Kids'},
  {MAL_ID: 16, NAME: 'Magic'},
  {MAL_ID: 17, NAME: 'Martial arts'},
  {MAL_ID: 18, NAME: 'Mecha'},
  {MAL_ID: 19, NAME: 'Music'},
  {MAL_ID: 20, NAME: 'Parody'},
  {MAL_ID: 21, NAME: 'Samurai'},
  {MAL_ID: 22, NAME: 'Romance'},
  {MAL_ID: 23, NAME: 'School'},
  {MAL_ID: 24, NAME: 'Sci-Fi'},
  {MAL_ID: 25, NAME: 'Shoujo'},
  {MAL_ID: 26, NAME: 'Shoujo ai'},
  {MAL_ID: 27, NAME: 'Shounen'},
  {MAL_ID: 28, NAME: 'Shounen ai'},
  {MAL_ID: 29, NAME: 'Space'},
  {MAL_ID: 30, NAME: 'Sports'},
  {MAL_ID: 31, NAME: 'Super power'},
  {MAL_ID: 32, NAME: 'Vampire'},
  {MAL_ID: 33, NAME: 'Yaoi'},
  {MAL_ID: 34, NAME: 'Yuri'},
  {MAL_ID: 35, NAME: 'Harem'},
  {MAL_ID: 36, NAME: 'Slice of life'},
  {MAL_ID: 37, NAME: 'Supernatural'},
  {MAL_ID: 38, NAME: 'Military'},
  {MAL_ID: 39, NAME: 'Police'},
  {MAL_ID: 40, NAME: 'Psychological'},
  {MAL_ID: 41, NAME: 'Thriller'},
  {MAL_ID: 42, NAME: 'Seinen'},
  {MAL_ID: 43, NAME: 'Josei'}
];

//Schedule related
const List<Map> WEEKDAYS = [
  {MAL_ID: 'monday', NAME: 'Monday'},
  {MAL_ID: 'tuesday', NAME: 'Tuesday'},
  {MAL_ID: 'wednesday', NAME: 'Wednesday'},
  {MAL_ID: 'thursday', NAME: 'Thursday'},
  {MAL_ID: 'friday', NAME: 'Friday'},
  {MAL_ID: 'saturday', NAME: 'Saturday'},
  {MAL_ID: 'sunday', NAME: 'Sunday'}
];

List<Map> getSortedGenres() {
  List<Map> genres = List.from(ANIME_GENRES);
  genres.sort((a, b) => a[NAME].compareTo(b[NAME]));
  return genres;
}

//Type related
const List<Map> ANIME_TYPES = [
  {MAL_ID: 'tv', NAME: 'TV'},
  {MAL_ID: 'ova', NAME: 'OVA'},
  {MAL_ID: 'movie', NAME: 'Movie'},
  {MAL_ID: 'special', NAME: 'Special'},
  {MAL_ID: 'ona', NAME: 'ONA'},
  {MAL_ID: 'music', NAME: 'Music'}
];

//State related
const List<Map> ANIME_STATE = [
  {MAL_ID: 'airing', NAME: 'Airing'},
  {MAL_ID: 'completed', NAME: 'Completed'},
  {MAL_ID: 'to_be_aired', NAME: 'Upcoming'}
];
