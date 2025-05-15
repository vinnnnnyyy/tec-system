import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './style.css'
import './plugins/axios'

/* Import Font Awesome core */
import { library } from '@fortawesome/fontawesome-svg-core'
/* Import Font Awesome component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
/* Import specific icons */
import { 
    faHome, 
    faQuestionCircle, 
    faSignOutAlt,
    faGraduationCap,
    faEye, 
    faEyeSlash, 
    faEnvelope, 
    faLock, 
    faUser, 
    faUserPlus, 
    faSignInAlt,
    faCheckCircle,
    faExclamationCircle,
    faInfoCircle,
    faExclamationTriangle,
    faTimes,
    faCircleNotch,
    faCog,
    faBullhorn,
    faPencilAlt,
    faIdCard,
    faBuilding,
    faUserCircle,
    faChartBar,
    faKey
} from '@fortawesome/free-solid-svg-icons'

/* Add icons to the library */
library.add(
    faHome, 
    faQuestionCircle, 
    faSignOutAlt,
    faGraduationCap,
    faEye, 
    faEyeSlash, 
    faEnvelope, 
    faLock, 
    faUser, 
    faUserPlus, 
    faSignInAlt,
    faCheckCircle,
    faExclamationCircle,
    faInfoCircle,
    faExclamationTriangle,
    faTimes,
    faCircleNotch,
    faCog,
    faBullhorn,
    faPencilAlt,
    faIdCard,
    faBuilding,
    faUserCircle,
    faChartBar,
    faKey
)

const app = createApp(App)
const pinia = createPinia()

/* Register Font Awesome component globally */
app.component('font-awesome-icon', FontAwesomeIcon)

app.use(pinia)
app.use(router)
app.mount('#app') 
