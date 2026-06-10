let currentLanguage = 'es';
let isGuest = false;

// Objeto de sesión listo para mapear la respuesta de tu backend
let currentUser = {
    name: "",
    career: "",
    bio: "",
    avatar: ""
};

// Arreglos vacíos esperando tus peticiones Fetch / Axios
let posts = [];
let companies = [];
let notifications = [];

// NAVEGACIÓN EN PANTALLAS DE AUTENTICACIÓN
function showCard(cardId) {
    document.querySelectorAll('.auth-screen').forEach(screen => screen.classList.remove('active'));
    document.getElementById(cardId).classList.add('active');
}

function executeRegister() {
    if(!document.getElementById('accept-terms').checked) {
        alert(currentLanguage === 'es' ? "Debes aceptar los términos y condiciones primero." : "You must accept the terms and conditions first.");
        return;
    }
    
    // Aquí puedes capturar para tu Fetch:
    const nameInput = document.getElementById('reg-name').value;
    const careerInput = document.getElementById('reg-career').value;
    const emailInput = document.getElementById('reg-email').value;
    const passInput = document.getElementById('reg-pass').value;

    // Conexión simulada temporal:
    currentUser.name = nameInput || "Nuevo Usuario";
    currentUser.career = careerInput || "Estudiante";
    isGuest = false;
    
    initApp();
}

function executeLogin() {
    // Aquí irá tu lógica de verificación (e.g., fetch a tu endpoint de login)
    const emailInput = document.getElementById('log-email').value;
    const passInput = document.getElementById('log-pass').value;

    // Setter temporal para pruebas de interfaz:
    currentUser.name = "Usuario Autenticado";
    currentUser.career = "Ingeniería";
    isGuest = false;
    
    initApp();
}

function loginAsGuest() {
    isGuest = true;
    currentUser.name = "Invitado / Guest";
    currentUser.career = "Ninguna / None";
    initApp();
}

function acceptTermsFromView() {
    showCard('card-register');
    document.getElementById('accept-terms').checked = true;
}

// NAVEGACIÓN SISTEMA INTERNO
function switchView(viewId, element) {
    document.querySelectorAll('.view-section').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.menu-item').forEach(m => m.classList.remove('active'));
    
    document.getElementById(viewId).classList.add('active');
    if(element) element.classList.add('active');
}

function initApp() {
    document.getElementById('auth-container').style.display = 'none';
    document.getElementById('app-container').style.display = 'flex';
    
    document.getElementById('edit-name').value = currentUser.name;
    document.getElementById('edit-career').value = currentUser.career;
    document.getElementById('edit-bio').value = currentUser.bio;
    document.getElementById('edit-avatar').value = currentUser.avatar;
    document.getElementById('profile-preview-img').src = currentUser.avatar || "";

    if(isGuest) {
        document.getElementById('guest-block-jobs').style.display = 'block';
        document.getElementById('guest-block-games').style.display = 'block';
    } else {
        document.getElementById('guest-block-jobs').style.display = 'none';
        document.getElementById('guest-block-games').style.display = 'none';
    }

    updateStatusNavbar();
    renderFeed();
    renderCompanies();
    renderNotifications();
    applyTranslations();
}

function updateStatusNavbar() {
    document.getElementById('user-display-status').innerText = `${currentUser.name} | ${currentUser.career}`;
    document.getElementById('date-indicator').innerText = new Date().toLocaleDateString();
}

function renderFeed() {
    const feed = document.getElementById('news-feed');
    const myPostsContainer = document.getElementById('my-posts-container');
    feed.innerHTML = "";
    myPostsContainer.innerHTML = "";

    if (posts.length === 0) {
        feed.innerHTML = `<p style="text-align:center; color:#888; padding:20px;">No hay publicaciones disponibles en este momento.</p>`;
        myPostsContainer.innerHTML = `<p style="text-align:center; color:#888; padding:10px;">No has realizado publicaciones.</p>`;
        return;
    }

    posts.forEach(post => {
        let mediaHtml = "";
        if(post.image) mediaHtml = `<img src="${post.image}" class="post-media">`;
        else if(post.video) mediaHtml = `<iframe class="post-media" src="${post.video}" frameborder="0" allowfullscreen style="height:240px;"></iframe>`;

        let deleteButtonHtml = "";
        if(!isGuest && post.author === currentUser.name) {
            deleteButtonHtml = `<button class="delete-btn" onclick="deletePost(${post.id})">🗑️</button>`;
        }

        let postTemplate = `
            <div class="post-card">
                ${deleteButtonHtml}
                <div class="post-header">
                    <img src="${post.avatar || 'https://via.placeholder.com/45'}" class="avatar">
                    <div class="post-info">
                        <h4>${post.author}</h4>
                        <span>${post.date}</span>
                    </div>
                </div>
                <div class="post-content">
                    <p>${post.desc}</p>
                    <strong style="color:var(--primary-dark);">${post.tags}</strong>
                    ${mediaHtml}
                </div>
                <div class="post-actions">
                    <button class="like-btn ${post.likedByMe ? 'liked' : ''}" onclick="toggleLike(${post.id})">
                        ❤️ <span id="like-count-${post.id}">${post.likes}</span> Likes
                    </button>
                </div>
            </div>
        `;

        feed.innerHTML += postTemplate;

        if(post.author === currentUser.name) {
            myPostsContainer.innerHTML += postTemplate;
        }
    });
}

function toggleLike(postId) {
    if(isGuest) return;
    let post = posts.find(p => p.id === postId);
    if(post) {
        if(post.likedByMe) {
            post.likes--;
            post.likedByMe = false;
        } else {
            post.likes++;
            post.likedByMe = true;
        }
        renderFeed();
    }
}

function deletePost(postId) {
    if(confirm(currentLanguage === 'es' ? "¿Deseas eliminar la publicación?" : "Delete this post?")) {
        posts = posts.filter(p => p.id !== postId);
        renderFeed();
    }
}

function createNewPost() {
    if(isGuest) return;
    const desc = document.getElementById('post-desc').value;
    const tags = document.getElementById('post-tags').value;
    const img = document.getElementById('post-img').value;
    const video = document.getElementById('post-video').value;

    if(!desc) return;

    // Estructura lista para enviar al backend mediante POST
    const newPost = {
        id: Date.now(),
        author: currentUser.name,
        avatar: currentUser.avatar,
        date: "Hace ",
        desc: desc,
        tags: tags,
        image: img,
        video: video,
        likes: 0,
        likedByMe: false
    };

    posts.unshift(newPost);

    document.getElementById('post-desc').value = "";
    document.getElementById('post-tags').value = "";
    document.getElementById('post-img').value = "";
    document.getElementById('post-video').value = "";
    
    renderFeed();
    switchView('view-home', document.querySelector('[data-view="view-home"]'));
}

function saveProfile() {
    currentUser.name = document.getElementById('edit-name').value;
    currentUser.career = document.getElementById('edit-career').value;
    currentUser.bio = document.getElementById('edit-bio').value;
    currentUser.avatar = document.getElementById('edit-avatar').value;

    updateStatusNavbar();
    renderFeed();
    alert("Perfil actualizado localmente.");
}

function renderCompanies() {
    const container = document.getElementById('companies-container');
    container.innerHTML = "";

    if (companies.length === 0) {
        container.innerHTML = `<p style="grid-column: 1/-1; text-align:center; color:#888;">No hay vacantes de estadías cargadas.</p>`;
        return;
    }

    companies.forEach(c => {
        container.innerHTML += `
            <div class="company-card">
                <div class="company-logo">${c.logo || ' '}</div>
                <h4>${c.name}</h4>
                <p style="font-size:12px; color:#666; margin: 8px 0;">${c.desc}</p>
                <button class="btn btn-secondary" onclick="openModal('${c.name}')" data-es="Ver detalles" data-en="View details">Ver detalles</button>
            </div>
        `;
    });
}

function renderNotifications() {
    const list = document.getElementById('notif-list');
    document.getElementById('notif-count').innerText = notifications.length;
    list.innerHTML = "";

    if (notifications.length === 0) {
        list.innerHTML = `<p style="text-align:center; color:#888;">No tienes notificaciones pendientes.</p>`;
        return;
    }

    notifications.forEach(n => {
        list.innerHTML += `
            <div style="padding:10px; border-left:4px solid var(--primary-dark); background:#f9f9f9; display:flex; justify-content:space-between; font-size:13px;">
                <div><strong>${n.user}</strong> <span>${currentLanguage === 'es' ? n.text_es : n.text_en}</span></div>
                <span style="font-size:11px; color:#999;">${n.date}</span>
            </div>
        `;
    });
}

function toggleLanguage() {
    currentLanguage = currentLanguage === 'es' ? 'en' : 'es';
    applyTranslations();
}

function applyTranslations() {
    document.querySelectorAll('[data-es]').forEach(elem => {
        elem.innerText = currentLanguage === 'es' ? elem.getAttribute('data-es') : elem.getAttribute('data-en');
    });
    renderNotifications();
}

function openModal(companyName) {
    if(isGuest) return;
    document.getElementById('modal-company-title').innerText = companyName;
    document.getElementById('details-modal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('details-modal').style.display = 'none';
}

function logout() {
    location.reload();
}