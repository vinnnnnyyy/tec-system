// ApplicationFormStore.js
// A shared state service for storing form data between components

import { reactive } from 'vue';

// Try to load initial state from localStorage if available
const loadInitialState = () => {
  try {
    const savedData = localStorage.getItem('applicationFormData');
    const hasSubmitted = localStorage.getItem('applicationFormHasSubmitted');
    
    return {
      formData: savedData ? JSON.parse(savedData) : {},
      hasSubmittedData: hasSubmitted === 'true'
    };
  } catch (e) {
    console.error('Error loading state from localStorage:', e);
    return {
      formData: {},
      hasSubmittedData: false
    };
  }
};

const state = reactive(loadInitialState());

// ApplicationFormStore singleton
const ApplicationFormStore = {
  // Get the current state
  state,
  
  // Set the form data
  setFormData(data) {
    this.state.formData = data;
    
    // Persist to localStorage
    try {
      localStorage.setItem('applicationFormData', JSON.stringify(data));
    } catch (e) {
      console.error('Error saving form data to localStorage:', e);
    }
  },
  
  // Get the form data
  getFormData() {
    return this.state.formData;
  },
  
  // Set the hasSubmittedData flag
  setHasSubmittedData(value) {
    this.state.hasSubmittedData = value;
    
    // Persist to localStorage
    try {
      localStorage.setItem('applicationFormHasSubmitted', value.toString());
    } catch (e) {
      console.error('Error saving hasSubmittedData to localStorage:', e);
    }
  },
  
  // Clear all data
  clearData() {
    this.state.formData = {};
    this.state.hasSubmittedData = false;
    
    // Clear from localStorage
    try {
      localStorage.removeItem('applicationFormData');
      localStorage.removeItem('applicationFormHasSubmitted');
    } catch (e) {
      console.error('Error clearing data from localStorage:', e);
    }
  }
};

export default ApplicationFormStore; 