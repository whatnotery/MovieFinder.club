import axios from 'axios'

export let csrfToken = document.querySelector('meta[name=csrf-token]').content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

export async function currentUser() {
    const response = await axios.get("/users/current_user", {
    });
    const user = await response.data
    return user
}

export async function deleteSession() {
    try {
        const response = await axios.delete("/users/sign_out", {
        });
        if (response.status == 200) {
            window.location.href = "/"
        } else {
            throw new Error("Failed to logout");
        }
    } catch (error) {
        console.error("Error deleting item:", error);
    }
}