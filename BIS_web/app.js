let currentLanguage = 'es';
let isGuest = false;

// Objeto de sesión listo para mapear la respuesta de tu backend
let currentUser = {
    name: "",
    career: "",
    bio: "",
    avatar: "Lechuzas/Logo.png"
};

// Variables globales al inicio de tu app.js
let tempPostMedia = "";     /* Guarda el archivo en Base64 */
let tempPostMediaType = ""; /* Guarda si es 'image' o 'video' */

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
    
    // Verificamos si existen antes de asignarles valor
    const nameEl = document.getElementById('edit-name');
    if(nameEl) nameEl.value = currentUser.name;

    const careerEl = document.getElementById('edit-career');
    if(careerEl) careerEl.value = currentUser.career;

    const bioEl = document.getElementById('edit-bio');
    if(bioEl) bioEl.value = currentUser.bio;

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
    const navAvatar = document.getElementById('nav-avatar'); // O el ID que tenga tu foto del menú
    if (navAvatar) {
        navAvatar.src = currentUser.avatar;
    }
    document.getElementById('user-display-status').innerText = `${currentUser.name} | ${currentUser.career}`;
    document.getElementById('date-indicator').innerText = new Date().toLocaleDateString();
}

function renderFeed() {
    // ESTA LÍNEA ES OBLIGATORIA
    const feed = document.getElementById('news-feed'); 
    const myPostsContainer = document.getElementById('my-posts-container');
    
    // Si no encuentra el contenedor, salimos para que no de error
    if (!feed) return; 

    feed.innerHTML = "";
    if (myPostsContainer) myPostsContainer.innerHTML = "";

    if (posts.length === 0) {
        feed.innerHTML = `<p style="text-align:center; color:#888; padding:20px;">No hay publicaciones disponibles en este momento.</p>`;
        myPostsContainer.innerHTML = `<p style="text-align:center; color:#888; padding:10px;">No has realizado publicaciones.</p>`;
        return;
    }

    posts.forEach(post => {
        // ========================================================
        // AQUÍ SE DECIDE SI SE DIBUJA UNA IMAGEN O UN VIDEO DE LA PC
        // ========================================================
        let mediaHtml = "";
        if(post.image) {
            mediaHtml = `<img src="${post.image}" class="post-media">`;
        } else if(post.video) {
            // Cambiamos el iframe por una etiqueta video con controles para archivos locales
            mediaHtml = `<video src="${post.video}" class="post-media" controls style="max-height:300px; width:100%; background:black; border-radius:6px;"></video>`;
        }

        let deleteButtonHtml = "";
        if(!isGuest && post.author === currentUser.name) {
            deleteButtonHtml = `<button class="delete-btn" onclick="deletePost(${post.id})">🗑️</button>`;
        }

        let postTemplate = `
            <div class="post-card">
                ${deleteButtonHtml}
                <div class="post-header">                  
                  <img src="${post.avatar && post.avatar !== '' ? post.avatar : 'Lechuzas/Logo.png'}" class="avatar">
                    <div class="post-info">
                        <h4>${post.author}</h4>
                        <span>${post.date}</span>
                    </div>
                </div>
                <div class="post-content">
                    <p>${post.desc}</p>
                    <strong style="color:var(--primary-dark);">${post.tags}</strong>
                    <div style="margin-top:10px;">${mediaHtml}</div>
                </div>
                <div class="post-actions">
                    <button class="like-btn ${post.likedByMe ? 'liked' : ''}" onclick="toggleLike(${post.id})">
                        🌟 <span id="like-count-${post.id}">${post.likes}</span> Likes
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

        feed.innerHTML += postTemplate;

        if(post.author === currentUser.name) {
            myPostsContainer.innerHTML += postTemplate;
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

    if(!desc) return;

    // Estructura del nuevo post adaptada para archivos multimedia locales
    const newPost = {
        id: Date.now(),
        author: currentUser.name,
        avatar: currentUser.avatar,
        date: "Hace un momento",
        desc: desc,
        tags: tags,
        image: tempPostMediaType === 'image' ? tempPostMedia : "", // Si es imagen, se guarda aquí
        video: tempPostMediaType === 'video' ? tempPostMedia : "", // Si es video, se guarda aquí
        likes: 0,
        likedByMe: false
    };

    posts.unshift(newPost);

    // Limpiamos los campos del formulario y las variables temporales
    document.getElementById('post-desc').value = "";
    document.getElementById('post-tags').value = "";
    document.getElementById('post-media-file').value = ""; // Resetea el input de la PC
    tempPostMedia = "";
    tempPostMediaType = "";
    
    renderFeed();
    switchView('view-home', document.querySelector('[data-view="view-home"]'));
     // Agrega esto adentro del final de tu función createNewPost() actual:
    document.getElementById('dropzone-prompt').style.display = 'block';
    document.getElementById('dropzone-preview-container').style.display = 'none';
    document.getElementById('dropzone-preview-container').innerHTML = "";
}

function saveProfile() {
    currentUser.name = document.getElementById('edit-name').value;
    currentUser.career = document.getElementById('edit-career').value;
    currentUser.bio = document.getElementById('edit-bio').value;
    // currentUser.avatar = document.getElementById('edit-avatar').value;

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
// Función para procesar la imagen de la PC y mostrarla al instante
function previewLocalImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            const previewImg = document.getElementById('profile-preview-img');
            if (previewImg) {
                previewImg.src = e.target.result;
            }
            
            // 1. Guardamos la foto en el usuario actual
            currentUser.avatar = e.target.result;
            
            // 2. ¡AQUÍ ESTÁ EL TRUCO! Llamamos a tu función para que actualice el Navbar de inmediato
            updateStatusNavbar();
        }
        
        reader.readAsDataURL(input.files[0]);
    }
}
function handlePostMedia(input) {
    const promptZone = document.getElementById('dropzone-prompt');
    const previewContainer = document.getElementById('dropzone-preview-container');
    
    if (input.files && input.files[0]) {
        const file = input.files[0];
        const reader = new FileReader();
        
        reader.onload = function(e) {
            tempPostMedia = e.target.result; // Base64 listo
            
            // Ocultamos el texto original de la nube
            promptZone.style.display = 'none';
            previewContainer.innerHTML = "";
            previewContainer.style.display = 'block';
            
            // Evaluamos el tipo de archivo y creamos su etiqueta correspondiente
            if (file.type.startsWith('video/')) {
                tempPostMediaType = 'video';
                previewContainer.innerHTML = `<video src="${e.target.result}" class="dropzone-preview-element" autoplay loop muted style="height:100%; width:100%; object-fit:contain; background:#000;"></video>`;
            } else if (file.type.startsWith('image/')) {
                tempPostMediaType = 'image';
                previewContainer.innerHTML = `<img src="${e.target.result}" class="dropzone-preview-element" style="height:100%; width:100%; object-fit:contain;">`;
            }
        }
        
        reader.readAsDataURL(file);
    } else {
        // Si cancela la selección, regresamos el diseño a su estado inicial
        tempPostMedia = "";
        tempPostMediaType = "";
        promptZone.style.display = 'block';
        previewContainer.style.display = 'none';
        previewContainer.innerHTML = "";
    }
}