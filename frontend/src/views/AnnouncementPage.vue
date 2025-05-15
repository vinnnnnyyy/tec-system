<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-8 text-blue-800">Examination Passers Announcement</h1>
    
    <div class="bg-white shadow-lg rounded-lg overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full table-auto">
          <thead class="bg-blue-600 text-white">
            <tr>
              <th class="px-6 py-4 text-left">Application No.</th>
              <th class="px-6 py-4 text-left">Name</th>
              <th class="px-6 py-4 text-left">School</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="passer in examPassers" :key="passer.appNo" class="hover:bg-gray-50">
              <td class="px-6 py-4">{{ passer.appNo }}</td>
              <td class="px-6 py-4 font-medium">{{ passer.name }}</td>
              <td class="px-6 py-4">{{ passer.school }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const examPassers = ref([
  {
    appNo: "2024-001",
    name: "John Michael Santos",
    school: "University of Manila"
  },
  {
    appNo: "2024-002",
    name: "Maria Clara Dela Cruz",
    school: "Polytechnic University of the Philippines"
  },
  {
    appNo: "2024-003",
    name: "Robert James Tan",
    school: "University of the East"
  },
  {
    appNo: "2024-004",
    name: "Angela Marie Garcia",
    school: "Far Eastern University"
  },
  {
    appNo: "2024-005",
    name: "Christian Paul Reyes",
    school: "Adamson University"
  },
  {
    appNo: "2024-006",
    name: "Patricia Ann Mendoza",
    school: "University of Santo Tomas"
  },
  {
    appNo: "2024-007",
    name: "Mark Anthony Cruz",
    school: "National University"
  },
  {
    appNo: "2024-008",
    name: "Sofia Isabel Lopez",
    school: "De La Salle University"
  },
  {
    appNo: "2024-009",
    name: "Daniel Joseph Ramos",
    school: "Mapua University"
  },
  {
    appNo: "2024-010",
    name: "Michelle Andrea Torres",
    school: "Ateneo de Manila University"
  }
])
</script>

<style scoped>
.container {
  max-width: 1200px;
}

table {
  border-collapse: collapse;
  width: 100%;
}

th {
  font-weight: 600;
}

tr:last-child td {
  border-bottom: none;
}
</style> 