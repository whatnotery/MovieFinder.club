<script>
    import axios from "axios";
    let formData = {
        user: {
            email: null,
            password: null,
        },
    };

    async function submit() {
        try {
            const response = await axios.post("/users/sign_in", formData);

            window.location.href = "/discover";
        } catch (error) {
            console.error("Error submitting form:", error);
        }
    }
</script>

<form on:submit|preventDefault={submit} class="flex flex-col items-center">
    <h3 class="text-4xl text-teal-500">Sign In</h3>

    <div class="py-2 my-4">
        <label for="email" hidden>Email</label>
        <input
            class="rounded-full border-teal-500"
            name="email"
            type="text"
            placeholder="Email"
            autocomplete="email"
            bind:value={formData.user.email}
        />
        <label for="password" hidden>Password</label>
        <input
            class="rounded-full border-teal-500"
            name="password"
            type="password"
            placeholder="Password"
            autocomplete="current-password"
            bind:value={formData.user.password}
        />
    </div>
    <button
        class="rounded-full w-32 text-orange-100 bg-teal-500 py-2 hover:text-orange-200"
        type="submit">Sign in</button
    >
</form>
