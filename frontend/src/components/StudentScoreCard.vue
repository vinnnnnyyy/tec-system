<template>
  <div class="bg-white rounded-lg shadow-sm border p-4 sm:p-6">
    <h3 class="text-lg sm:text-xl font-medium mb-4 sm:mb-6 text-gray-800 border-b pb-3">Exam Score Details</h3>
    
    <div v-if="examScore">
      <!-- Header Info -->
      <div class="mb-4 sm:mb-6 flex flex-col sm:flex-row gap-2 justify-start sm:justify-between items-start sm:items-center">
        <div class="flex flex-wrap gap-2">
          <span class="bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-md inline-flex items-center">
            <span class="whitespace-nowrap">App #:</span> 
            <span class="ml-1 max-w-[100px] sm:max-w-none truncate font-medium">{{ examScore.app_no || 'N/A' }}</span>
          </span>
          
          <span v-if="examScore.exam_type" class="bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-md">
            {{ examScore.exam_type }}
          </span>
        </div>
        
        <span class="bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-md flex items-center">
          <i class="far fa-calendar-alt mr-1"></i>
          {{ formatDate(examScore.exam_date) }}
        </span>
      </div>
      
      <!-- Score Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4 mb-4 sm:mb-6">
        <div v-for="(part, index) in scoreParts" 
             :key="index"
             class="border rounded-lg overflow-hidden">
          <div class="border-b p-3 sm:p-4 bg-gray-50">
            <h4 class="font-medium text-gray-700 text-xs sm:text-sm">{{ part.label }}</h4>
          </div>
          <div class="p-3 sm:p-4 flex items-center justify-center">
            <div class="text-2xl sm:text-3xl font-bold text-gray-800">
              {{ part.value || 'N/A' }}
            </div>
          </div>
        </div>
      </div>
      
      <!-- Overall Ability Percentile Rank -->
      <div v-if="examScore.oapr" class="border rounded-lg overflow-hidden">
        <div class="border-b p-3 sm:p-4 bg-gray-100">
          <h4 class="font-medium text-gray-800 text-xs sm:text-sm">{{ oaprLabel }}</h4>
        </div>
        <div class="p-4 sm:p-6 flex items-center justify-center">
          <div class="text-4xl sm:text-5xl font-bold text-gray-800">
            {{ examScore.oapr || 'N/A' }}
          </div>
        </div>
      </div>

    </div>
    
    <div v-else class="text-center py-6 sm:py-8 text-gray-500">
      <i class="fas fa-chart-line text-3xl sm:text-4xl mb-3 sm:mb-4 text-gray-300"></i>
      <p class="text-base sm:text-lg font-medium mb-2">No exam scores available yet</p>
      <p class="text-xs sm:text-sm mt-2">Scores will appear here after your exam has been graded and uploaded.</p>
      <p class="text-2xs sm:text-xs mt-4 text-gray-400">If you've already taken your exam and it's been more than 2 weeks, please contact the admissions office.</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    examScore: {
      type: Object,
      default: null
    },
    modelInfo: {
      type: Object,
      default: null
    }
  },
  computed: {
    // Dynamically extract score parts from the examScore
    scoreParts() {
      if (!this.examScore) return [];
      
      // Define the mapping of score parts to their display labels
      let scorePartDefinitions = [
        { key: 'part1', label: 'English Proficiency' },
        { key: 'part2', label: 'Reading Comprehension' },
        { key: 'part3', label: 'Science Process Skills' },
        { key: 'part4', label: 'Quantitative Skills' },
        { key: 'part5', label: 'Abstract Thinking Skills' }
      ];
      
      // If model info with labels is provided, use those labels
      if (this.modelInfo && this.modelInfo.labels) {
        scorePartDefinitions = Object.keys(this.modelInfo.labels)
          .filter(key => key !== 'oapr') // Exclude OAPR as it's handled separately
          .map(key => ({
            key,
            label: this.modelInfo.labels[key]
          }));
      }
      
      // Filter out parts that don't exist in the data
      return scorePartDefinitions
        .filter(part => this.examScore[part.key] !== undefined && this.examScore[part.key] !== null)
        .map(part => ({
          key: part.key,
          label: part.label,
          value: this.examScore[part.key]
        }));
    },
    
    // Get OAPR label from model info if available
    oaprLabel() {
      if (this.modelInfo && this.modelInfo.labels && this.modelInfo.labels.oapr) {
        return this.modelInfo.labels.oapr;
      }
      return 'Overall Ability Percentile Rank (OAPR)';
    }
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return 'Exam date not available';
      const date = new Date(dateString);
      
      // Use a shorter date format on mobile
      if (window.innerWidth < 640) {
        return date.toLocaleDateString('en-US', { 
          year: 'numeric', 
          month: 'short', 
          day: 'numeric' 
        });
      }
      
      return date.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
      });
    }
  }
}
</script>

<style scoped>
/* Text size for very small screens */
.text-2xs {
  font-size: 0.65rem;
  line-height: 1rem;
}

/* Media query for adjusting layout on very small mobile devices */
@media (max-width: 360px) {
  .text-2xl {
    font-size: 1.25rem;
    line-height: 1.75rem;
  }
  
  .p-3 {
    padding: 0.5rem;
  }
  
  .gap-2 {
    gap: 0.25rem;
  }
}
</style> 