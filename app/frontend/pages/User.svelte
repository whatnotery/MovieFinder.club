<script>
    import axios from "axios";
    export let userData;
    import FilmGrid from "../components/filmGrid.svelte";
    let films = [];
    async function getLikedFilms() {
        const response = await axios.get(`/users/${userData.user_name}/likes`);
        return response.data;
    }
    let filmsPromise = getLikedFilms();

    filmsPromise
        .then((result) => {
            films = result;
        })
        .catch((error) => {
            // Handle errors
        });
</script>

<h2>{userData.user_name}</h2>

<h3>Liked Films:</h3>
<FilmGrid {films} />

<style>
    h2,
    h3 {
        font-family: "helvetica";
    }
</style>
