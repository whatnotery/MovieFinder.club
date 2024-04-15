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

<form on:submit|preventDefault={submit}>
    <label for="email" hidden>Email</label>

    <input
        name="email"
        type="text"
        placeholder="Email"
        autocomplete="email"
        bind:value={formData.user.email}
    />
    <label for="password" hidden>Password</label>
    <input
        name="password"
        type="password"
        placeholder="Password"
        autocomplete="current-password"
        bind:value={formData.user.password}
    />
    <button type="submit">Sign in</button>
</form>
