<script>
    import axios from "axios";
    import ShowReview from "./showReview.svelte";
    export let reviews;
    export let userPage;
    let currentPage = 1;
    const itemsPerPage = 4;

    function changePage(newPage) {
        currentPage = newPage;
    }

    async function getFilm(mdb_id) {
        try {
            const response = await axios.get(`/api/films/${mdb_id}`);
            return response.data;
        } catch (error) {
            console.error("Failed to fetch film data:", error);
            return null;
        }
    }

    $: totalPages = Math.ceil(reviews.length / itemsPerPage);
    $: startIndex = (currentPage - 1) * itemsPerPage;
    $: endIndex = currentPage * itemsPerPage;
    $: paginatedReviews = reviews.slice(startIndex, endIndex);
</script>

<div>
    {#if reviews && reviews.length > 0}
        {#if reviews.length > itemsPerPage}
            <div class="pb-4 flex justify-center">
                <button
                    class="rounded-full w-10 text-orange-100 bg-teal-500 hover:text-orange-200"
                    on:click={() => changePage(currentPage - 1)}
                    disabled={currentPage === 1}
                >
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
                <span class="font-bold text-teal-500 mx-2">
                    {currentPage} of {totalPages}
                </span>
                <button
                    class="rounded-full w-10 text-orange-100 bg-teal-500 hover:text-orange-200"
                    on:click={() => changePage(currentPage + 1)}
                    disabled={currentPage === totalPages}
                >
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>
        {/if}

        <div
            class="flex flex-row flex-wrap w-full justify-center md:justify-start"
        >
            {#each paginatedReviews as review}
                <div class="w-[300px] px-4">
                    {#await getFilm(review.mdb_id)}
                        <p>Loading film details...</p>
                    {:then film}
                        {#if userPage && film}
                            <a
                                class="font-bold text-xl text-teal-500 hover:text-teal-600"
                                href="/films/{film.mdb_id}"
                            >
                                Review for {film.title}
                            </a>
                        {/if}
                    {:catch error}
                        <p>Error loading film details: {error.message}</p>
                    {/await}
                    <ShowReview {review} {userPage} />
                </div>
            {/each}
        </div>
    {:else}
        <p>No reviews to display.</p>
    {/if}
</div>
