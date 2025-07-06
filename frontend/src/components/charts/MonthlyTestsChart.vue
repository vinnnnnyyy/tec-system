<template>
  <div class="h-64">
    <canvas :id="canvasId" class="w-full h-full"></canvas>
  </div>
</template>

<script>
import { onMounted, onUnmounted, ref, watch, nextTick } from 'vue'
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
    
    const createChart = async () => {
      // Wait for next tick to ensure DOM is ready
      await nextTick()
      
      const canvasElement = document.getElementById(props.canvasId)
      if (!canvasElement) {
        console.log('Canvas element not found:', props.canvasId)
        return false
      }
      
      // Destroy existing chart if it exists
      if (chart.value) {
        try {
          chart.value.destroy()
        } catch (error) {
          console.warn('Error destroying existing chart:', error)
        }
        chart.value = null
      }
      
      // Check if we have data
      if (!props.data || props.data.length === 0) {
        console.log('No data available for monthly tests chart')
        return false
      }
      
      // Check if canvas context is available
      const ctx = canvasElement.getContext('2d')
      if (!ctx) {
        console.warn('Canvas context not available for:', props.canvasId)
        return false
      }
      
      // Clear any existing content
      ctx.clearRect(0, 0, canvasElement.width, canvasElement.height)
      
      console.log('Creating chart with canvas:', props.canvasId, 'context:', ctx)
      
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
        
        console.log('Monthly chart created successfully')
        return true
      } catch (error) {
        console.error('Error creating chart:', error)
        return false
      }
    }
    
    onMounted(async () => {
      // Ensure DOM is fully rendered and Vue has updated
      await nextTick()
      
      console.log('MonthlyTestsChart mounted with data:', props.data)
      
      // Use timeout to ensure DOM is fully rendered and stable
      setTimeout(async () => {
        // Only create chart if we have valid data
        if (props.data && Array.isArray(props.data) && props.data.length > 0) {
          const success = await createChart()
          if (!success) {
            console.log('MonthlyTestsChart: Initial chart creation failed, will retry when data changes')
          }
        } else {
          console.log('MonthlyTestsChart mounted but no data available yet')
        }
      }, 300) // Reduced timeout for better responsiveness
    })
    
    onUnmounted(() => {
      if (chart.value) {
        try {
          chart.value.destroy()
        } catch (error) {
          console.warn('Error destroying chart on unmount:', error)
        }
        chart.value = null
      }
    })
    
    watch(() => props.data, async (newData) => {
      console.log('Monthly chart data changed:', newData)
      if (newData && Array.isArray(newData) && newData.length > 0) {
        // Add delay to prevent rapid re-creation and ensure DOM is ready
        setTimeout(async () => {
          try {
            const success = await createChart()
            if (!success) {
              console.warn('Chart creation failed during data change')
            }
          } catch (error) {
            console.warn('Error recreating chart:', error)
          }
        }, 300)
      } else {
        // If data becomes empty, destroy the chart
        if (chart.value) {
          try {
            chart.value.destroy()
            chart.value = null
          } catch (error) {
            console.warn('Error destroying chart when data cleared:', error)
          }
        }
      }
    }, { deep: true })
    
    return {}
  }
}
</script>
