<script>
    export let filmData = {};
    import { onMount } from "svelte";
    import Like from "../components/Like.svelte";
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
                    <h2>{filmData.title}</h2>

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

                        <Like filmId={filmData.mdb_id} />
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

<style>
    #wrap {
        font-family: "Montserrat", sans-serif;
        min-height: 95vh;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
    }

    #main {
        max-width: 65%;
        background-color: ghostwhite;
        padding: 5px 10px;
        margin-top: 30px;
        border-radius: 15px;
        -webkit-box-shadow: 0px 6px 15px 4px rgba(0, 0, 0, 0.5);
        box-shadow: 0px 6px 15px 4px rgba(0, 0, 0, 0.5);
        border: lightgrey 1px solid;
    }

    #filmWrap {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    #filmtext {
        margin-left: 20px;
        max-width: 30rem;
    }

    img {
        margin-top: 10px;
        border-radius: 5px;
        max-width: 15rem;
    }

    #filmContainer {
        display: flex;
        overflow: scroll;
    }

    @media (max-width: 768px) {
        #filmWrap {
            flex-direction: column;
            max-width: 65%;
        }
    }
    @media (max-width: 600px) {
        #filmWrap {
            flex-direction: column;
            max-width: 85%;
        }

        #filmtext {
            max-width: 80%;
            margin-left: 0;
        }
    }
</style>
