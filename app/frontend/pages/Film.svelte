<script>
    import axios from "axios";
    export let filmData = {};
    export let liked;
    export let favorite;
    import Favorite from "../components/favorite.svelte";
    import LikeUnlike from "../components/LikeUnlike.svelte";
    import ReviewList from "../components/reviewList.svelte";
    import { currentUser } from "../lib/auth";
    let userPromise = currentUser();

    let user = {};
    userPromise
        .then((result) => {
            user = result;
        })
        .catch((error) => {
            // Handle errors
        });

    async function fetchRandomFilm() {
        window.location.href = "/discover";
    }

    async function getReviews() {
        const response = await axios.get(`/films/${filmData.mdb_id}/reviews`);
        return response.data;
    }
    let reviewsPromise = getReviews();
</script>

<section
    class="flex flex-col items-center justify-center pt-7 md:flex-row md:items-start"
>
    <div class="md:pl-9 md:min-w-80 md:flex md:flex-col md:items-center">
        {#if filmData.poster}
            <img
                class="w-64"
                src="https://image.tmdb.org/t/p/w300/{filmData.poster}"
                alt={`Movie poster for ${filmData.title}`}
            />
        {/if}
    </div>
    <div class="text-center md:text-left">
        <span class="flex flex-col md:flex-row items-center">
            <h2 class="font-bold w-6/12 text-2xl text-teal-500 my-6 pr-4">
                {filmData.title} ({filmData.year})
            </h2>
            <span class="text-nowrap m-2">
                <a
                    class="rounded-full w-full h-10 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                    href={filmData.youtube_link}
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    <i class="fa-brands fa-youtube"></i>
                </a>
            </span>
            {#if user.id}
                <Favorite filmId={filmData.mdb_id} {favorite} />
                <LikeUnlike filmId={filmData.mdb_id} {liked} />
                <button
                    class="rounded-full w-40 h-10 text-orange-100 bg-teal-500 m-2 py-2 hover:text-orange-200"
                    on:click={fetchRandomFilm}
                >
                    discover more <i class="fa-solid fa-film"></i></button
                >
            {/if}
        </span>

        <span class="md:flex md:flex-col md:items-start">
            <p>{filmData.plot}</p>

            <b>Streaming Providers:</b>
            <p>
                {filmData?.streaming_providers?.length > 0
                    ? filmData.streaming_providers.join(", ")
                    : "None"}
            </p>
            <b>Rental Providers:</b>
            <p>
                {filmData?.rental_providers?.length > 0
                    ? filmData.rental_providers.join(", ")
                    : "None"}
            </p>
        </span>
    </div>
</section>
<div class="md:pl-9">
    <div class="w-full flex flex-row flex-wrap justify-between my-2">
        <h2 class="font-bold text-2xl text-teal-500 pr-4">Reviews:</h2>
        {#if user.id}
            <a
                href="/films/{filmData.mdb_id}/review"
                class="rounded-full w-32 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                >new review <i class="fa-solid fa-plus"></i></a
            >
        {/if}
    </div>

    {#await reviewsPromise}
        <p>...waiting</p>
    {:then reviews}
        <ReviewList {reviews} userPage="false" />
    {:catch error}
        <p style="color: red">{error.message}</p>
    {/await}
</div>
