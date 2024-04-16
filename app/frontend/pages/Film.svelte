<script>
    export let filmData = {};
    export let liked;
    import { onMount } from "svelte";
    import LikeUnlike from "../components/LikeUnlike.svelte";
    import axios from "axios";
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
</script>

<div id="wrap">
    <section id="main">
        <div id="filmWrap" class="">
            <div id="filmContainer">
                <section>
                    {#if filmData.poster}
                        <img
                            src="https://image.tmdb.org/t/p/w300/{filmData.poster}"
                            alt={`Movie poster for ${filmData.title}`}
                        />
                    {/if}
                </section>
                <section id="filmtext">
                    <h2 class="text-3xl">{filmData.title}</h2>

                    <a
                        href={`https://www.themoviedb.org/movie/${filmData.mdb_id}`}
                        target="_blank"
                        rel="noopener noreferrer">The Movie DB</a
                    >
                    |
                    <a
                        href={filmData.youtube_link}
                        target="_blank"
                        rel="noopener noreferrer">Youtube Trailer</a
                    >
                    {#if user.id}
                        <button on:click={fetchRandomFilm}
                            >Discover New Film</button
                        >

                        <LikeUnlike filmId={filmData.mdb_id} {liked} />
                    {/if}
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
                </section>
            </div>
        </div>
    </section>
</div>
