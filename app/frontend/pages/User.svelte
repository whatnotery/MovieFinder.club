<script>
    export let user;
    export let userFavorites;
    export let userLikes;
    export let userReviews;
    import FilmGrid from "../components/filmGrid.svelte";
    import ReviewList from "../components/reviewList.svelte";
</script>

<section
    class="w-full flex flex-col items-center justify-around md:items-start md:pl-5"
>
    <div class="pl-10">
        <div class="flex flex-col w-full md:flex-row">
            <div class="flex flex-row w-4/12">
                <div class="">
                    <h2 class="font-bold py-5 text-4xl text-teal-500">
                        @{user.user_name}
                    </h2>

                    <p>{user.bio}</p>
                    <div class="pt-5">
                        {#if user.letterboxd}
                            <p>
                                <a
                                    class="rounded-full w-full h-10 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                                    href="https://letterboxd.com/{user.letterboxd}"
                                >
                                    letterboxd <i
                                        class="fa-brands fa-letterboxd"
                                    ></i></a
                                >
                            </p>
                        {/if}
                        <br />
                        {#if user.instagram}
                            <p>
                                <a
                                    class="rounded-full w-full h-10 text-orange-100 bg-teal-500 p-2 hover:text-orange-200"
                                    href="https://instagram.com/{user.instagram}"
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
                    <FilmGrid films={userFavorites} />
                </div>
            </div>
        </div>
        <div class="flex flex-col w-80 md:w-full">
            <h3 class="font-bold py-5 text-4xl text-teal-500">reviews:</h3>
            <ReviewList reviews={userReviews} userPage={true} />
        </div>
        <div class="flex flex-col w-80 md:w-full">
            <h3 class="font-bold py-5 text-4xl text-teal-500">likes:</h3>
            <FilmGrid films={userLikes} />
        </div>
    </div>
</section>
