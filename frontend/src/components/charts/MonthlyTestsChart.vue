<template>
  <div class="h-64">
    <canvas :id="canvasId" class="w-full h-full"></canvas>
  </div>
</template>

<script>
import { onMounted, onUnmounted, ref, watch } from 'vue'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  BarController,
  Title,
  Tooltip,
  Legend,
} from 'chart.js'

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  BarController,
  Title,
  Tooltip,
  Legend
)

export default {
  name: 'MonthlyTestsChart',
  props: {
    data: {
      type: Array,
      default: () => []
    },
    canvasId: {
      type: String,
      default: 'monthly-tests-chart'
    }
  },
  setup(props) {
    const chart = ref(null)
    
    const createChart = () => {
      const ctx = document.getElementById(props.canvasId)
      if (!ctx) {
        console.log('Canvas element not found:', props.canvasId)
        return
      }
      
      // Destroy existing chart if it exists
      if (chart.value) {
        chart.value.destroy()
        chart.value = null
      }
      
      // Check if we have data
      if (!props.data || props.data.length === 0) {
        console.log('No data available for monthly tests chart')
        return
      }
      
      // Prepare data
      const months = props.data.map(item => {
        const date = new Date(item.month + '-01')
        return date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
      })
      
      const counts = props.data.map(item => item.count)
      
      console.log('Monthly chart data:', { months, counts })
      
      try {
        // Create new chart
        chart.value = new ChartJS(ctx, {
          type: 'bar',
          data: {
            labels: months,
            datasets: [{
              label: 'Tests Conducted',
              data: counts,
              backgroundColor: 'rgba(59, 130, 246, 0.8)',
              borderColor: 'rgba(59, 130, 246, 1)',
              borderWidth: 1,
              borderRadius: 4,
              borderSkipped: false,
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false
              },
              title: {
                display: false
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  stepSize: 1,
                  color: '#6B7280'
                },
                grid: {
                  color: '#E5E7EB'
                }
              },
              x: {
                ticks: {
                  color: '#6B7280'
                },
                grid: {
                  display: false
                }
              }
            }
          }
        })
      } catch (error) {
        console.error('Error creating chart:', error)
      }
    }
    
    onMounted(() => {
      // Use timeout to ensure DOM is fully rendered
      setTimeout(() => {
        if (props.data && props.data.length > 0) {
          createChart()
        }
      }, 200)
    })
    
    onUnmounted(() => {
      if (chart.value) {
        chart.value.destroy()
      }
    })
    
    watch(() => props.data, (newData) => {
      console.log('Monthly chart data changed:', newData)
      if (newData && newData.length > 0) {
        // Add delay to prevent rapid re-creation and ensure DOM is ready
        setTimeout(() => {
          createChart()
        }, 300)
      }
    }, { deep: true })
    
    return {}
  }
}
</script>
