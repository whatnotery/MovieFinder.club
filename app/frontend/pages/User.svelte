<script>
    import axios from "axios";
    export let userData;
    import FilmGrid from "../components/filmGrid.svelte";
    import ReviewList from "../components/reviewList.svelte";
    async function getLikedFilms() {
        const response = await axios.get(`/users/${userData.user_name}/likes`);
        return response.data;
    }
    async function getFavorites() {
        const response = await axios.get(
            `/users/${userData.user_name}/favorites`,
        );
        return response.data;
    }
    async function getReviews() {
        const response = await axios.get(
            `/users/${userData.user_name}/reviews`,
        );
        return response.data;
    }
    let filmsPromise = getLikedFilms();
    let favoritesPromise = getFavorites();
    let reviewsPromise = getReviews();
</script>

<section
    class="w-full flex flex-col items-center justify-around md:items-start md:pl-5"
>
    <div class="pl-10">
        <div class="flex flex-col w-full md:flex-row">
            <div class="flex flex-row w-4/12">
                <div class="">
                    <h2 class="font-bold py-5 text-4xl text-teal-500">
                        @{userData.user_name}
                    </h2>

                    <p>{userData.bio}</p>
                    <div class="pt-5">
                        {#if userData.letterboxd}
                            <p>
                                <a
                                    class="rounded-full w-full h-10 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                                    href="https://letterboxd.com/{userData.letterboxd}"
                                >
                                    letterboxd <i
                                        class="fa-brands fa-letterboxd"
                                    ></i></a
                                >
                            </p>
                        {/if}
                        <br />
                        {#if userData.instagram}
                            <p>
                                <a
                                    class="rounded-full w-full h-10 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                                    href="https://instagram.com/{userData.instagram}"
                                >
                                    instagram <i class="fa-brands fa-instagram"
                                    ></i></a
                                >
                            </p>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="flex flex-col w-80 md:pl-16 md:w-full">
                <h3 class="font-bold py-5 text-4xl text-teal-500">
                    favorites:
                </h3>
                <div class="flex flex-row">
                    {#await favoritesPromise}
                        <p>...waiting</p>
                    {:then favorites}
                        <FilmGrid films={favorites} />
                    {:catch error}
                        <p style="color: red">{error.message}</p>
                    {/await}
                </div>
            </div>
        </div>
        <div class="flex flex-col w-80 md:w-full">
            <h3 class="font-bold py-5 text-4xl text-teal-500">reviews:</h3>
            {#await reviewsPromise}
                <p>...waiting</p>
            {:then reviews}
                <ReviewList {reviews} userPage="true" />
            {:catch error}
                <p style="color: red">{error.message}</p>
            {/await}
        </div>
        <div class="flex flex-col w-80 md:w-full">
            <h3 class="font-bold py-5 text-4xl text-teal-500">likes:</h3>
            {#await filmsPromise}
                <p>...waiting</p>
            {:then likedFilms}
                <FilmGrid films={likedFilms} />
            {:catch error}
                <p style="color: red">{error.message}</p>
            {/await}
        </div>
    </div>
</section>
