<template>
  <div class="bg-gray-100 py-8 min-h-screen" :class="{ 'py-0': popupMode, 'hidden-for-pdf-generation': outputPdfOnly }">
    <div class="form-container mx-auto shadow print:shadow-none" ref="formContainer">
  
      <div class="text-wmsu top-section">
        <!-- Header Row -->
        <div class="flex justify-between items-start mb-4">
          <!-- Left Section -->
          <div class="w-1/4 flex">
            <div class="pr-1 w-40">
              <!-- Form ID and Instructions -->
              <div class="flex justify-center items-center">
                <div class="relative">
                  <img src="@/assets/images/Screenshot 2025-04-03 151538.png" alt="Certification Logos" class="h-32">
                </div>
              </div>
            </div>
          </div>
            
          <!-- University Info -->
          <div class="text-center">
            <div class="flex items-center">
              <div class="w-full">
                <p class="text-[13px] font-bold mt-4 mr-15">Western Mindanao State University</p>
                <p class="text-[20px] font-bold text-wmsu mt-1 mb-1 mr-15">TESTING AND EVALUATION CENTER</p>
                <p class="text-[12px] mb-2 mr-15">Zamboanga City</p>
              </div>
            </div>
            
            <p class="text-[16px] font-bold mb-0 mr-15 text-wmsu">WMSU-CET APPLICATION FORM</p>
            <p class="text-[17px] font-bold mt-0 mr-15">for School Year {{ schoolYear }}</p>
          </div>

          <div class="mt-4 w-1/5">
            <img src="../assets/images/wmsu_cert.png" class="max-w-full">
          </div>
          
          <!-- Right Side: FREE and Photo Box -->
          <div class="w-1/4 text-right flex flex-col items-end">
            <p class="text-[9px] mr-1 mb-0">THIS FORM IS FOR <span class="font-bold text-[12px]">FREE</span></p>
            <div class="flex">
              <div class="mb-2">
              </div>
              <div class="photo-box flex items-center ml-50">
                <div class="flex items-center justify-center">
                  <img src="../assets/images/profile.png" class="w-[2in] h-[2in]">
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Name and Personal Info -->
        <div class="mb-1">
          <div class="flex items-center text-[10px]">
            <p class="font-bold underline mr-1">NAME:</p>
            <div class="field-line flex-1">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.name ? form.name.toUpperCase() : '' }}</span>
              </div>
            </div>
            <p class="ml-1">Date of Birth:</p>
            <div class="border border-wmsu w-8 h-5 mx-0.5 text-center">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.birthMonth ? form.birthMonth.toUpperCase() : '' }}</span>
              </div>
            </div>
            <div class="border border-wmsu w-8 h-5 mx-0.5 text-center">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.birthDay ? form.birthDay.toUpperCase() : '' }}</span>
              </div>
            </div>
            <div class="border border-wmsu w-10 h-5 mx-0.5 text-center">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.birthYear ? form.birthYear.toUpperCase() : '' }}</span>
              </div>
            </div>
          </div>
          
          <div class="flex ml-10 text-[8px] italic">
            <span>(Pls. PRINT)</span>
            <span class="ml-10">Family Name,</span>
            <span class="ml-10">First Name</span>
            <span class="ml-10">Middle Name</span>
          </div>
          
          <!-- Sex, Age and Home Address -->
          <div class="flex items-center text-[10px] mt-2">
            <p>Sex assigned at birth:</p>
            <span class="flex items-center ml-1">
              <input v-model="form.sex" type="radio" value="male" class="mr-1 mt-2 accent-wmsu">
              Male
            </span>
            <span class="flex items-center ml-1">
              <input v-model="form.sex" type="radio" value="female" class="mr-2  mt-2 accent-wmsu">
              Female
            </span>
            <span class="ml-2">Age:</span>
            <div class="flex">
              <div class="border border-wmsu w-8 h-5 text-center mt-1 ml-1">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ form.age ? form.age.toString().toUpperCase() : '' }}</span>
                </div>
              </div>
            </div>
            <span class="ml-2">Home Address:</span>
            <div class="field-line flex-1 ml-1">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.address ? form.address.toUpperCase() : '' }}</span>
              </div>
            </div>
          </div>
          
          <!-- Citizenship, Contact, Email -->
          <div class="flex items-center text-[10px] mt-2">
            <p>Citizenship:</p>
            <div class="field-line w-28 mx-1">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.citizenship ? form.citizenship.toUpperCase() : '' }}</span>
              </div>
            </div>
            <p>Contact No.:</p>
            <div class="field-line w-28 mx-1">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.contactNumber ? form.contactNumber.toUpperCase() : '' }}</span>
              </div>
            </div>
            <p>Email Address:</p>
            <div class="field-line flex-1 ml-1">
              <div class="pdf-friendly-input">
                <span class="input-text">{{ form.email ? form.email.toUpperCase() : '' }}</span>
              </div>
            </div>
          </div>
          
          <!-- WMSUCET question -->
          <div class="mt-2">
            <table class="w-full">
              <tbody>
              <tr>
                <td class="w-1/2">
                  <p class="text-[10px] font-bold uppercase text-wmsu">IS THIS YOUR FIRST TIME TO TAKE THE WMSUCET?</p>
                </td>
                <td class="w-1/2 pl-4">
                  <p class="text-[10px] text-wmsu">If No, how many times have you already taken it?</p>
                </td>
                <td class="pl-4">
                  <div class="field-line w-full mt-1">
                    <div class="pdf-friendly-input">
                      <span class="input-text">{{ form.timesTaken ? form.timesTaken.toUpperCase() : '' }}</span>
                    </div>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="flex items-center ml-4">
                    <input v-model="form.isFirstTime" type="radio" value="yes" class="accent-wmsu mr-1 mt-2">
                    <span class="font-bold text-wmsu mr-5 text-[10px]">YES</span>
                    <input v-model="form.isFirstTime" type="radio" value="no" class="accent-wmsu mr-1 mt-2">
                    <span class="font-bold text-wmsu text-[10px]">NO</span>
                  </div>
                </td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <!-- Type of Applicant -->
        <div class="mb-2">
          <p class="text-[10px] font-bold uppercase mb-0">
            <span class="underline">TYPE OF APPLICANT</span>:
          </p>
          
          <!-- Dynamic Applicant Fields Based on Type -->
          <div v-if="form.applicantType || form.schoolName" class="mt-2">
            <!-- Title based on applicant type -->
            <p class="font-bold uppercase mb-2 text-[10px]">
              {{ getApplicantTypeTitle(form.applicantType) }}
            </p>
            
            <!-- School Name Field -->
            <div class="flex mt-1">
              <p class="text-[10px]">{{ getSchoolLabel() }}</p>
              <div class="field-line flex-1 mx-1">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ form.schoolName ? form.schoolName.toUpperCase() : '' }}</span>
                </div>
              </div>
              <!-- Graduation Date or Course field based on type -->
              <p class="text-[10px]">{{ getSecondaryLabel() }}</p>
              <div class="field-line w-28 ml-1">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ form.applicantType === 'college_student' ? (form.course ? form.course.toUpperCase() : '') : (form.graduationDate ? form.graduationDate.toUpperCase() : '') }}</span>
                </div>
              </div>
            </div>
            
            <!-- School Address Field -->
            <div class="flex items-center">
              <p class="text-[10px]">School Address:</p>
              <div class="field-line flex-1 ml-1">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ form.schoolAddress ? form.schoolAddress.toUpperCase() : '' }}</span>
                </div>
              </div>
            </div>
            <p class="text-[8px] italic text-right">(Write in full, do not abbreviate)</p>
          
          </div>
        </div>
        
        <!-- Test Information Table -->
        <div class="mb-2 section-spacing">
          <p class="text-[9px] italic text-center mb-1">To be filled out by person authorized to receive and/or process application</p>
          
          <table class="w-full mt-0 border-collapse border border-wmsu text-center table-spacing">
            <tbody>
            <tr class="text-wmsu text-[9px] font-bold">
              <td class="table-cell border border-wmsu py-1">Test Date</td>
              <td class="table-cell border border-wmsu py-1">Test Center</td>
              <td class="table-cell border border-wmsu py-1">Room No.</td>
              <td class="table-cell border border-wmsu py-1">Test Time</td>
              <td class="table-cell border border-wmsu py-1">
                <div>Test Center</div>
                <div class="text-[8px]">Code</div>
              </td>
              <td class="table-cell border border-wmsu py-1">
                <div>High School</div>
                <div class="text-[8px]">Code</div>
              </td>
            </tr>
            <tr>
              <td class="table-cell border border-wmsu h-11">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ appointmentInfo.test_date ? formatAppointmentDate(appointmentInfo.test_date).toUpperCase() : ((appointmentInfo.date) ? formatAppointmentDate(appointmentInfo.date).toUpperCase() : 'TO BE ASSIGNED') }}</span>
                </div>
              </td>
              <td class="table-cell border border-wmsu">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ appointmentInfo.test_center ? appointmentInfo.test_center.toUpperCase() : 'TO BE ASSIGNED' }}</span>
                </div>
              </td>
              <td class="table-cell border border-wmsu">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ (appointmentInfo.room_number ? (appointmentInfo.room_number + (appointmentInfo.room_code ? ' ' + appointmentInfo.room_code : '')).toUpperCase() : 'TO BE ASSIGNED') }}</span>
                </div>
              </td>
              <td class="table-cell border border-wmsu">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ appointmentInfo.time_slot ? formatTimeSlot(appointmentInfo.time_slot).toUpperCase() : 'TO BE ASSIGNED' }}</span>
                </div>
              </td>
              <td class="table-cell border border-wmsu">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ appointmentInfo.test_center_code ? appointmentInfo.test_center_code.toUpperCase() : 'TO BE ASSIGNED' }}</span>
                </div>
              </td>
              <td class="table-cell border border-wmsu">
                <div class="pdf-friendly-input">
                  <span class="input-text">{{ form.highSchoolCode ? form.highSchoolCode.toUpperCase() : 'NOT PROVIDED' }}</span>
                </div>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Signature Lines -->
        <div class="flex justify-between mb-2 text-[9px]">
          <div class="w-1/3 mt-8 mb-6">
            <div class="border-t border-wmsu pt-0 text-center mt-6 mx-10">
              <p class="mb-0">School's Official Contact Person</p>
              <p class="mt-0">(Print Name & Signature)</p>
            </div>
          </div>
          
          <div class="w-1/3 mx-16 mt-14 text-center">
            <div class="border-t border-wmsu pt-0">
              <p>TEC Registration Officer</p>
            </div>
          </div>
          
          <div class="w-1/3 text-right mt-12">
            <p class="font-bold text-[11px]">TEST CENTER COPY</p>
          </div>
        </div>
      </div>
      
      <!-- Perforated Line -->
      <div class="relative">
        <div class="dashed-line w-full"></div>
        <div class="absolute -right-1 top-1/2 transform -translate-y-1/2 text-xs text-wmsu">▶</div>
        <div class="absolute -left-1 top-1/2 transform -translate-y-1/2 text-xs text-wmsu">◀</div>
      </div>
      
      <!-- Bottom Part - Test Permit Section -->
      <div class="text-wmsu relative bottom-section mt-4">
        <!-- Side Tab -->
      
        
        <!-- Main Content -->
        <div class="ml-6">
          <div class="flex justify-between items-start mb-1">
            <div class="w-full">
              <div class="flex items-start">
                <div class="flex-grow">
                  <div class="flex justify-between w-full">
                    <p class="font-bold text-[10px]">WMSU-TEC-FR-002.04</p>
                    <p class="font-bold text-[13px]">TEST PERMIT-WMSU CET SY {{ schoolYear }}</p>
                  </div>
                  <p class="text-[8px] italic">Effective Date: 19-Aug-2024</p>
                  
                  <div class="mt-2 w-full">
                    <div class="flex w-full items-center">
                      <p class="font-bold text-[10px] mr-1 whitespace-nowrap">NAME:</p>
                      <div class="border-b border-wmsu flex-grow">
                        <div class="pdf-friendly-input">
                          <span class="input-text">{{ form.name ? form.name.toUpperCase() : '' }}</span>
                        </div>
                      </div>
                    </div>
                    <p class="text-[8px] italic">(Pls. PRINT) Family Name, First Name, Middle Name</p>
                  </div>
                  
                  <div class="mt-2 w-full">
                    <div class="flex w-full items-center">
                      <p class="text-[10px] mr-1 whitespace-nowrap">School:</p>
                      <div class="border-b border-wmsu flex-grow ">
                        <div class="pdf-friendly-input">
                          <span class="input-text">{{ form.schoolName ? form.schoolName.toUpperCase() : '' }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Test Information -->
          <div class="mb-2 section-spacing mt-3">
            <p class="text-[8px] italic mb-1 flex text-center justify-center">To be filled out by person authorized to receive and/or process application</p>
            
            <table class="w-full border-collapse border border-wmsu text-center mt-0 table-spacing">
              <tbody>
              <tr class="text-wmsu text-[9px] font-bold">
                <td class="table-cell border border-wmsu py-1">Test Date</td>
                <td class="table-cell border border-wmsu py-1">Test Center</td>
                <td class="table-cell border border-wmsu py-1">Room No.</td>
                <td class="table-cell border border-wmsu py-1">Test Time</td>
                <td class="table-cell border border-wmsu py-1">
                  <div>Test Center</div>
                  <div class="text-[8px]">Code</div>
                </td>
                <td class="table-cell border border-wmsu py-1">
                  <div>High School</div>
                  <div class="text-[8px]">Code</div>
                </td>
              </tr>
              <tr>
                <td class="table-cell border border-wmsu h-11">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ appointmentInfo.test_date ? formatAppointmentDate(appointmentInfo.test_date).toUpperCase() : ((appointmentInfo.date) ? formatAppointmentDate(appointmentInfo.date).toUpperCase() : 'TO BE ASSIGNED') }}</span>
                  </div>
                </td>
                <td class="table-cell border border-wmsu">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ appointmentInfo.test_center ? appointmentInfo.test_center.toUpperCase() : 'TO BE ASSIGNED' }}</span>
                  </div>
                </td>
                <td class="table-cell border border-wmsu">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ (appointmentInfo.room_number ? (appointmentInfo.room_number + (appointmentInfo.room_code ? ' ' + appointmentInfo.room_code : '')).toUpperCase() : 'TO BE ASSIGNED') }}</span>
                  </div>
                </td>
                <td class="table-cell border border-wmsu">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ appointmentInfo.time_slot ? formatTimeSlot(appointmentInfo.time_slot).toUpperCase() : 'TO BE ASSIGNED' }}</span>
                  </div>
                </td>
                <td class="table-cell border border-wmsu">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ appointmentInfo.test_center_code ? appointmentInfo.test_center_code.toUpperCase() : 'TO BE ASSIGNED' }}</span>
                  </div>
                </td>
                <td class="table-cell border border-wmsu">
                  <div class="pdf-friendly-input">
                    <span class="input-text">{{ form.highSchoolCode ? form.highSchoolCode.toUpperCase() : 'NOT PROVIDED' }}</span>
                  </div>
                </td>
              </tr>
              </tbody>
            </table>
          </div>
          
          <!-- Bottom Section -->
          <div class="flex justify-between text-[10px]">
            <!-- Left Side -->
            <div class="w-1/4">
              <div class="text-center mt-12">
                <div class="border-t border-wmsu pt-0 text-center mt-6 mx-10">
                  <p class="mb-0">School's Official Contact Person</p>
                  <p class="mt-0">(Print Name & Signature)</p>
                </div>
              </div>
              
              <div class="mt-10 text-center">
                <div class="border-t border-wmsu pt-0">
                  <p class="mb-0">School's Contact Person / TEC Reg. Officer</p>
                  <p class="text-[8px] mt-0">Print Name & Signature</p>
                </div>
              </div>
            </div>
            
            <!-- Middle - Student Type Checkboxes -->
            <div class="w-2/5 mt-8">
              <div class="font-bold text-center mb-1">STUDENT TYPE (check one)</div>
              <div class="ml-3">
                <div class="flex items-center mt-1">
                  <input type="checkbox" :checked="form.applicantType === 'senior_high_student'" disabled class="w-3 h-3 mr-1 mt-0 accent-wmsu">
                  <p :class="{'font-bold': form.applicantType === 'senior_high_student'}">Senior High School graduating student</p>
                </div>
                <div class="flex items-center mt-1">
                  <input type="checkbox" :checked="form.applicantType === 'senior_high_graduate'" disabled class="w-3 h-3 mr-1 mt-0 accent-wmsu">
                  <p :class="{'font-bold': form.applicantType === 'senior_high_graduate'}">Senior High School graduate (has not enrolled in College)</p>
                </div>
                <div class="flex items-center mt-2">
                  <input type="checkbox" :checked="form.applicantType === 'college_student' && form.collegeType === 'wmsu_main'" disabled class="w-3 h-3 mr-1 accent-wmsu">
                  <p :class="{'font-bold': form.applicantType === 'college_student' && form.collegeType === 'wmsu_main'}">College, WMSU Main Campus (currently enrolled)</p>
                </div>
                <div class="flex items-center mt-1">
                  <input type="checkbox" :checked="form.applicantType === 'college_student' && form.collegeType === 'wmsu_external'" disabled class="w-3 h-3 mr-1 accent-wmsu">
                  <p :class="{'font-bold': form.applicantType === 'college_student' && form.collegeType === 'wmsu_external'}">College, WMSU External Studies Unit</p>
                </div>
                <div class="flex items-center mt-1">
                  <input type="checkbox" :checked="form.applicantType === 'college_student' && form.collegeType === 'non_wmsu'" disabled class="w-3 h-3 mr-1 accent-wmsu">
                  <p :class="{'font-bold': form.applicantType === 'college_student' && form.collegeType === 'non_wmsu'}">College, Non-WMSU (Transferee)</p>
                </div>
              </div>
              
              <!-- IMPORTANT Section -->
              <div class="mt-3 w-full text-center">
                <div class="bg-red-100 py-1 border border-wmsu">
                  <p class="font-bold text-[11px]">IMPORTANT</p>
                </div>
                <p class="text-[8px] mt-0">Read reminder at the back of this form</p>
              </div>
            </div>
            
            <!-- Right - Photo Box -->
            <div class="w-1/4 text-center flex flex-col items-end">
              <div class="photo-box flex items-center">
                <div class="flex items-center justify-center">
                  <img src="../assets/images/profile.png" class="w-[2in] h-[2in]">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Action Buttons -->
    <div v-if="!outputPdfOnly" class="flex justify-center mt-4 print:hidden" :class="{ 'flex-col space-y-2 px-4': popupMode && isMobileView }">
      <!-- When not in popup mode, show all buttons -->
      <template v-if="!popupMode">
        <button @click="printForm" class="bg-wmsu text-white px-6 py-2 rounded-lg mr-2 hover:bg-red-700 transition">Print Form</button>
        <button @click="downloadPDF" class="bg-green-600 text-white px-6 py-2 rounded-lg mr-2 hover:bg-green-700 transition">Download PDF</button>
        <button @click="router.push('/schedule')" class="bg-gray-600 text-white px-6 py-2 rounded-lg hover:bg-gray-700 transition mr-2">
          <i class="fas fa-arrow-left mr-2"></i>Return to Schedule
        </button>
        <button @click="reloadData" class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition mr-2">
          <i class="fas fa-sync-alt mr-2"></i>Reload Data
        </button>
        <button @click="enhancedRefreshTestDetails" class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition mr-2">
          <i class="fas fa-redo-alt mr-2"></i>Refresh Test Details
        </button>
        <button @click="showDebugInfo" class="bg-gray-700 text-white px-6 py-2 rounded-lg hover:bg-gray-800 transition">
          <i class="fas fa-bug mr-2"></i>Debug Info
        </button>
      </template>
      
      <!-- When in popup mode, only show Download PDF button -->
      <template v-else>
        <div :class="{ 'w-full flex justify-center': isMobileView }">
          <button @click="downloadPDF" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition" :class="{ 'w-full max-w-xs': isMobileView }">
          <i class="fas fa-file-download mr-2"></i>Download PDF
        </button>
        </div>
        
        <!-- Add refresh test details button in popup mode if we're missing test details -->
        <button v-if="!hasTestDetails" @click="fetchTestDetails(appointmentInfo.id)" class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition" :class="{ 'mt-2 ml-0': isMobileView, 'ml-2': !isMobileView }">
          <i class="fas fa-sync-alt mr-2"></i>Refresh Test Details
        </button>
      </template>
    </div>
    
    <!-- Debug Modal (only if not in popup mode and not outputPdfOnly) -->
    <div v-if="debugModalVisible && !popupMode && !outputPdfOnly" class="fixed inset-0 bg-gray-800 bg-opacity-75 flex items-center justify-center z-50 print:hidden">
      <div class="bg-white rounded-lg shadow-lg p-6 max-w-3xl w-full max-h-[80vh] overflow-auto">
        <h3 class="text-lg font-bold mb-4">Test Details Debug Information</h3>
        
        <div class="mb-4">
          <h4 class="font-semibold">Appointment ID: {{ appointmentInfo.id || 'Not set' }}</h4>
          <p class="text-sm text-gray-600">Last updated: {{ new Date(appointmentInfo.forceUpdate).toLocaleString() }}</p>
        </div>
        
        <div class="grid grid-cols-2 gap-4 mb-4">
          <div>
            <h4 class="font-semibold mb-2">Test Session</h4>
            <pre class="bg-gray-100 p-2 rounded text-xs">{{ JSON.stringify({
              test_date: appointmentInfo.test_date,
              exam_type: appointmentInfo.exam_type
            }, null, 2) }}</pre>
          </div>
          
          <div>
            <h4 class="font-semibold mb-2">Test Center</h4>
            <pre class="bg-gray-100 p-2 rounded text-xs">{{ JSON.stringify({
              test_center: appointmentInfo.test_center,
              test_center_code: appointmentInfo.test_center_code
            }, null, 2) }}</pre>
          </div>
          
          <div>
            <h4 class="font-semibold mb-2">Test Room</h4>
            <pre class="bg-gray-100 p-2 rounded text-xs">{{ JSON.stringify({
              room_number: appointmentInfo.room_number,
              room_code: appointmentInfo.room_code
            }, null, 2) }}</pre>
          </div>
          
          <div>
            <h4 class="font-semibold mb-2">Time Slot</h4>
            <pre class="bg-gray-100 p-2 rounded text-xs">{{ JSON.stringify({
              time_slot: appointmentInfo.time_slot,
              timeSlot: appointmentInfo.timeSlot,
              formatted: formatTimeSlot(appointmentInfo.time_slot || appointmentInfo.timeSlot)
            }, null, 2) }}</pre>
          </div>
        </div>
        
        <div class="mb-4">
          <h4 class="font-semibold mb-2">Complete AppointmentInfo Object</h4>
          <pre class="bg-gray-100 p-2 rounded text-xs max-h-40 overflow-auto">{{ JSON.stringify(appointmentInfo, null, 2) }}</pre>
        </div>
        
        <div class="mb-4 flex flex-wrap gap-2">
          <button 
            @click="forceTimeSlotRefresh" 
            class="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700"
          >
            <i class="fas fa-sync-alt mr-2"></i>Force Refresh Time Slot
          </button>
          <button 
            @click="clearTimeSlotCache" 
            class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
          >
            <i class="fas fa-eraser mr-2"></i>Clear Time Slot Cache
          </button>
          <button 
            @click="tryAllTimeSlotEndpoints" 
            class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
          >
            <i class="fas fa-search mr-2"></i>Try All API Endpoints
          </button>
        </div>
        
        <div class="flex justify-end">
          <button @click="debugModalVisible = false" class="bg-gray-600 text-white px-4 py-2 rounded hover:bg-gray-700">
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch, nextTick, computed } from 'vue'
import html2pdf from 'html2pdf.js'
import ApplicationFormStore from '@/services/ApplicationFormStore'
import { useRouter, useRoute } from 'vue-router'
import axiosInstance from '../services/axios.interceptor'
import axios from 'axios'

// Props
const props = defineProps({
  popupMode: {
    type: Boolean,
    default: false
  },
  appointmentData: {
    type: Object,
    default: null
  },
  outputPdfOnly: { // New prop
    type: Boolean,
    default: false
  },
  startDownload: { // New prop
    type: Boolean,
    default: false
  }
})

// Emit
const emit = defineEmits(['close', 'pdf-generation-complete'])

const formContainer = ref(null)
const isMobileView = ref(false)
const debugModalVisible = ref(false)

// ... (other existing refs and reactive objects: schoolYear, appointmentInfo, form, etc.)
const schoolYear = ref('2025-2026');
const appointmentInfo = reactive({ /* ... */ });
const form = reactive({ /* ... */ });
const hasTestDetails = computed(() => !!(appointmentInfo.test_date && appointmentInfo.test_center && appointmentInfo.room_number));
const formData = computed(() => (props.popupMode || props.outputPdfOnly) ? props.appointmentData : ApplicationFormStore.state.formData)
const hasSubmittedData = computed(() => (props.popupMode || props.outputPdfOnly) ? true : ApplicationFormStore.state.hasSubmittedData)

const router = useRouter();
const route = useRoute();

const loadFormData = () => {
  if (!hasSubmittedData.value) {
    return;
  }
  
  try {
    const testFormData = formData.value;
    if (!testFormData) {
      console.warn("[ApplicationForm] loadFormData called but formData.value (props.appointmentData) is null/undefined");
      return;
    }

    if (props.outputPdfOnly) {
      console.log('[ApplicationForm outputPdfOnly] Received testFormData (props.appointmentData) for School Info:',
        'applicantType:', testFormData.applicantType,
        'schoolName (top-level):', testFormData.schoolName, 
        'seniorGraduating:', testFormData.seniorGraduating,
        'seniorGraduate:', testFormData.seniorGraduate,
        'college:', testFormData.college
      );
      console.log('[ApplicationForm outputPdfOnly] Received testFormData (props.appointmentData) for WMSUCET Experience:',
        'wmsucetExperience:', testFormData.wmsucetExperience
      );
      console.log('[ApplicationForm outputPdfOnly] Received testFormData (props.appointmentData) for High School Code:',
        'highSchoolCode:', testFormData.highSchoolCode
      );
      console.log('[ApplicationForm outputPdfOnly] Received RAW applicantType from props:', testFormData.applicantType);
    }
    
    form.name = testFormData.fullName || '';
    form.birthMonth = testFormData.birthMonth || '';
    form.birthDay = testFormData.birthDay || '';
    form.birthYear = testFormData.birthYear || '';
    form.sex = testFormData.gender?.male ? 'male' : (testFormData.gender?.female ? 'female' : '');
    form.age = testFormData.age || '';
    form.address = testFormData.homeAddress || '';
    form.citizenship = testFormData.citizenship || '';
    form.contactNumber = testFormData.contactNumber || '';
    form.email = testFormData.email || '';
    
    if (props.outputPdfOnly) {
      console.log('[ApplicationForm outputPdfOnly] Populated form object:',
        'form.email:', form.email,
        'form.address:', form.address
      );
    }

    if (testFormData.appointmentId) {
      const appointmentId = parseInt(testFormData.appointmentId, 10) || testFormData.appointmentId;
      appointmentInfo.id = appointmentId;
      appointmentInfo.programName = testFormData.programName;
      appointmentInfo.date = testFormData.preferredDate;
      
      if (props.popupMode || props.outputPdfOnly) {
        if (testFormData.test_date) appointmentInfo.test_date = testFormData.test_date;
        if (testFormData.test_center) appointmentInfo.test_center = testFormData.test_center;
        if (testFormData.test_center_code) appointmentInfo.test_center_code = testFormData.test_center_code;
        if (testFormData.room_number) appointmentInfo.room_number = testFormData.room_number;
        if (testFormData.room_code) appointmentInfo.room_code = testFormData.room_code;
        if (testFormData.exam_type) appointmentInfo.exam_type = testFormData.exam_type;
        
        if (testFormData.timeSlot) {
            appointmentInfo.time_slot = testFormData.timeSlot;
            appointmentInfo.timeSlot = testFormData.timeSlot;
            appointmentInfo.reporting_time = testFormData.timeSlot === 'morning' ? '7:30 AM' : '12:30 PM';
        } else {
            appointmentInfo.time_slot = null;
            appointmentInfo.timeSlot = null;
            appointmentInfo.reporting_time = '';
        }
        appointmentInfo.forceUpdate = Date.now();
      }
      
      if (props.outputPdfOnly) {
        console.log('[ApplicationForm outputPdfOnly] Populated appointmentInfo object:',
          'appointmentInfo.test_date:', appointmentInfo.test_date,
          'appointmentInfo.test_center:', appointmentInfo.test_center,
          'appointmentInfo.test_center_code:', appointmentInfo.test_center_code,
          'appointmentInfo.room_number:', appointmentInfo.room_number,
          'appointmentInfo.room_code:', appointmentInfo.room_code,
          'appointmentInfo.time_slot:', appointmentInfo.time_slot
        );
      }

      if (!props.outputPdfOnly) {
      setTimeout(() => {
        fetchTestDetails(appointmentId);
      }, 500);
      }
    }

    // Applicant Type and School Info Mapping
    let applicantTypeMapping = {
      'senior_high_graduating': 'senior_high_student',
      'senior_high_graduate': 'senior_high_graduate',
      'college': 'college_student'
    };
    form.applicantType = applicantTypeMapping[testFormData.applicantType] || '';
    
    form.schoolName = ''; // Reset before conditional assignment
    form.schoolAddress = '';
    form.graduationDate = '';
    form.course = '';
    form.collegeType = '';

    if (testFormData.applicantType === 'senior_high_graduating') {
      form.schoolName = testFormData.seniorGraduating?.schoolName || testFormData.schoolName || '';
      form.schoolAddress = testFormData.seniorGraduating?.schoolAddress || '';
      form.graduationDate = testFormData.seniorGraduating?.graduationDate || '';
    } else if (testFormData.applicantType === 'senior_high_graduate') {
      form.schoolName = testFormData.seniorGraduate?.schoolName || testFormData.schoolName || '';
      form.schoolAddress = testFormData.seniorGraduate?.schoolAddress || '';
      form.graduationDate = testFormData.seniorGraduate?.graduationDate || '';
    } else if (testFormData.applicantType === 'college') {
      form.schoolName = testFormData.college?.schoolName || testFormData.schoolName || '';
      form.schoolAddress = testFormData.college?.schoolAddress || '';
      form.course = testFormData.college?.course || '';
      form.collegeType = testFormData.college?.collegeType || '';
    } else {
      // Fallback for unknown applicantType, perhaps use top-level schoolName if available
      form.schoolName = testFormData.schoolName || ''; 
    }

    if (props.outputPdfOnly) {
      console.log('[ApplicationForm outputPdfOnly] Populated form object (School Info):',
        'form.applicantType:', form.applicantType,
        'form.schoolName:', form.schoolName,
        'form.schoolAddress:', form.schoolAddress,
        'form.graduationDate:', form.graduationDate,
        'form.course:', form.course,
        'form.collegeType:', form.collegeType
      );
      console.log('[ApplicationForm outputPdfOnly] MAPPED form.applicantType:', form.applicantType);
    }

    // WMSUCET experience mapping
    form.isFirstTime = 'yes'; // Default to yes
    form.timesTaken = '';
    if (testFormData.wmsucetExperience) {
      form.isFirstTime = testFormData.wmsucetExperience.firstTime ? 'yes' : 
                        (testFormData.wmsucetExperience.notFirstTime ? 'no' : 'yes');
      form.timesTaken = testFormData.wmsucetExperience.timesTaken || '';
    }

    if (props.outputPdfOnly) {
      console.log('[ApplicationForm outputPdfOnly] Populated form object (School Info):',
        'form.applicantType:', form.applicantType,
        'form.schoolName:', form.schoolName,
        'form.schoolAddress:', form.schoolAddress,
        'form.graduationDate:', form.graduationDate,
        'form.course:', form.course,
        'form.collegeType:', form.collegeType
      );
      console.log('[ApplicationForm outputPdfOnly] Populated form object (WMSUCET Experience):',
        'form.isFirstTime:', form.isFirstTime,
        'form.timesTaken:', form.timesTaken
      );
    }

    // High School Code mapping
    form.highSchoolCode = testFormData.highSchoolCode || '';

    if (props.outputPdfOnly) {
      console.log('[ApplicationForm outputPdfOnly] Populated form object (High School Code):',
        'form.highSchoolCode:', form.highSchoolCode
      );
    }
  } catch (error) {
    console.error('Error loading form data:', error);
  }
}

const downloadPDF = () => {
  if (!formContainer.value) {
    console.error("Form container ref is not available for PDF generation.");
    if (props.outputPdfOnly) {
      emit('pdf-generation-complete', { success: false });
    }
    return;
  }
  const options = {
    margin: 0,
    filename: `WMSU-CET-Application-${form.name || 'Form'}${appointmentInfo.id ? '-Appt' + appointmentInfo.id : ''}.pdf`,
    image: { type: 'jpeg', quality: 0.98 },
    html2canvas: { scale: 2, useCORS: true, logging: false, letterRendering: true, scrollY: 0, windowWidth: document.documentElement.offsetWidth },
    jsPDF: { unit: 'in', format: 'legal', orientation: 'portrait', compress: true, hotfixes: ["px_scaling"] },
    pagebreak: { avoid: ['tr', 'td'] },
    html2canvas: { 
      windowHeight: formContainer.value.offsetHeight + 200,
      windowWidth: formContainer.value.offsetWidth,
      onclone: (doc) => { /* ... */ }
    }
  };
  
  html2pdf().from(formContainer.value).set(options).save().then(() => {
    if (props.outputPdfOnly) {
      emit('pdf-generation-complete', { success: true });
    } else if (props.popupMode) {
    setTimeout(() => {
      emit('close');
    }, 1000);
  }
  }).catch(err => {
    console.error("Error generating PDF:", err);
    if (props.outputPdfOnly) {
      emit('pdf-generation-complete', { success: false, error: err });
    }
  });
}

// ... (other existing methods: printForm, resetForm, formatters, fetchTestDetails, etc.)
const printForm = () => window.print();
const fetchTestDetails = async (id) => { /* ... */ };
const formatAppointmentDate = (dateString) => {
  if (!dateString) return ''; // Return empty string if input is falsy
  try {
    const date = new Date(dateString);
    // Check if date is valid
    if (isNaN(date.getTime())) {
      return ''; // Return empty string for invalid dates
    }
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long',
      day: 'numeric'
    });
  } catch (e) {
    console.warn('Error formatting date:', dateString, e);
    return ''; // Return empty string on error
  }
}
const formatTimeSlot = (slot) => {
  if (!slot) return ''; // Ensure empty string for falsy input
  if (slot === 'morning') {
    return 'Morning (8:00 AM - 12:00 PM)';
  } else if (slot === 'afternoon') {
    return 'Afternoon (1:00 PM - 5:00 PM)';
  }
  return slot.toString(); // Ensure it's a string if not morning/afternoon
}
const getApplicantTypeTitle = (type) => {
  if (props.outputPdfOnly) {
    console.log('[ApplicationForm outputPdfOnly] getApplicantTypeTitle called with type:', type);
  }
  let title = '';
  switch(type) {
    case 'senior_high_student':
      title = 'SENIOR HIGH SCHOOL GRADUATING STUDENT';
      break;
    case 'senior_high_graduate':
      title = 'SENIOR HIGH SCHOOL GRADUATE who has not enrolled in college.';
      break;
    case 'college_student':
      title = 'COLLEGE STUDENT';
      break;
    default:
      title = ''; // Explicitly empty for default
  }
  if (props.outputPdfOnly) {
    console.log('[ApplicationForm outputPdfOnly] getApplicantTypeTitle returning:', title);
  }
  return title;
};
const getSchoolLabel = () => { /* ... */ };
const getSecondaryLabel = () => { /* ... */ };
const reloadData = () => { /* ... */ };
const manualRefreshTestDetails = () => { /* ... */ };
const showDebugInfo = () => { debugModalVisible.value = true; };
const enhancedRefreshTestDetails = () => { /* ... */ };
const closePopup = () => emit('close');

const checkMobileView = () => {
  isMobileView.value = window.innerWidth < 768;
};

onMounted(async () => {
  checkMobileView();
  window.addEventListener('resize', checkMobileView);

  if ((props.popupMode || props.outputPdfOnly) && props.appointmentData) {
    loadFormData();
  } else if (!props.outputPdfOnly) { // Only do complex loading if not in outputPdfOnly mode
    // ... (existing onMounted logic for non-popup, non-outputPdfOnly mode) ...
    const routeAppointmentId = route.params.appointmentId;
    if (routeAppointmentId) { /* ... */ }
    // ... (localStorage checks, fetchLatestAppointment, etc.) ...
    loadFormData(); // ensure it is called after potential data fetch
  }

  // If in outputPdfOnly mode and startDownload is already true (e.g. if data was passed immediately)
  if (props.outputPdfOnly && props.startDownload && props.appointmentData) {
     await nextTick(); // Ensure DOM is updated with data
     if (formContainer.value) {
        downloadPDF();
    } else {
        console.warn("outputPdfOnly: formContainer not ready on mount for initial startDownload");
     }
  }
});

watch(() => props.startDownload, async (newValue) => {
  if (newValue && props.outputPdfOnly) {
    if (!props.appointmentData) {
        console.warn("startDownload triggered in outputPdfOnly mode, but no appointmentData provided.");
        emit('pdf-generation-complete', { success: false, error: 'No data' });
    return;
  }
    // Ensure data is loaded if it wasn't already on mount
    if (!form.name) { // Heuristic: if form.name is empty, data probably not loaded
      loadFormData();
    }
    await nextTick(); // Wait for DOM updates after loadFormData if it was called
    if (formContainer.value) {
      downloadPDF();
    } else {
      console.error("Cannot start PDF download: formContainer ref is not available.");
      emit('pdf-generation-complete', { success: false, error: 'formContainer not found' });
    }
  }
});

// Watch for appointmentData changes if in outputPdfOnly mode, to reload form data
watch(() => props.appointmentData, (newData) => {
    if (props.outputPdfOnly && newData) {
  loadFormData();
}
}, { deep: true });

// Cleanup
watch(() => props.popupMode, (newVal) => {
  if (newVal) checkMobileView();
});

// Remove the global exports, they are not best practice with <script setup>
</script>

<style scoped>
.hidden-for-pdf-generation {
  position: absolute !important;
  left: -9999px !important;
  top: -9999px !important;
  z-index: -1 !important;
  opacity: 0 !important;
  pointer-events: none !important;
  visibility: hidden !important;
  width: 8.5in !important; /* Ensure it has dimensions for html2pdf */
  height: 14in !important; /* Ensure it has dimensions for html2pdf */
  overflow: hidden !important;
}

@media print {
  @page {
    size: 8.5in 14in;
    margin: 0;
  }
  body {
    margin: 0;
    padding: 0;
    width: 8.5in;
    height: 14in;
  }
  .form-container {
    width: 8.5in;
    height: 14in;
    margin: 0;
    padding: 0.2in;
    box-sizing: border-box;
    box-shadow: none;
    border: none;
    transform: scale(0.98); /* Slightly shrink to fit on one page */
    transform-origin: top center;
  }
}

/* Adjust form dimensions to ensure it fits on a single page */
.form-container {
  background-color: white;
  border: 1px solid #d1d5db;
  max-width: 8.5in;
  width: 100%;
  padding: 0.2in;
  min-height: 14in; /* Changed from fixed height to min-height */
  margin: 0 auto;
  box-sizing: border-box;
  page-break-after: always;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  overflow: visible; /* Changed from hidden to visible */
}

/* Popup mode specific styles */
:deep([class*='popup-mode']) .form-container {
  margin: 0;
  border: none;
  box-shadow: none;
}

.text-wmsu {
  color: #bf0000;
}

.bg-wmsu {
  background-color: #bf0000;
}

.border-wmsu {
  border-color: #bf0000;
}

.photo-box {
  width: 2in; /* 2x2 inch size */
  height: 2in;
  background-color: #f9f9f9;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #ddd;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.field-line {
  border-bottom: 1px solid #bf0000;
  margin-bottom: 0.08in;
  position: relative;
}

.dashed-line {
  border-top: 1px dashed #bf0000;
  margin: 0.3in 0;
}

.vertical-ticket {
  writing-mode: vertical-rl;
  transform: rotate(180deg);
  position: absolute;
  left: -13px;
  top: 0;
  height: 80%;
  border-right: 2px solid #bf0000;
  border-top: 1px solid #bf0000;
  border-bottom: 1px solid #bf0000;
  padding: 2px;
  text-align: center;
  font-weight: bold;
  font-size: 6px;
  color: #bf0000;
  background: white;
  width: 33px;
}

.section-spacing {
  margin-bottom: 0.1in;
}

.table-spacing {
  margin: 0.1in 0;
}

.top-section {
  min-height: 54%; /* Changed from fixed height to min-height */
  overflow: visible; /* Changed from hidden to visible */
}

.bottom-section {
  min-height: 46%; /* Changed from fixed height to min-height */
  overflow: visible; /* Changed from hidden to visible */
}

input[type="radio"], input[type="checkbox"] {
  accent-color: #bf0000;
}

input {
  font-family: Arial, sans-serif;
}

/* Ensure text inputs don't show default styling */
input[type="text"] {
  border: none;
  padding: 0;
  margin: 0;
}

.pdf-friendly-input {
  margin-bottom: 5px;
}

.input-container {
  border-bottom: 1px solid #000;
  min-height: 24px;
  position: relative;
}

.input-text {
  position: relative;
  top: 0;
  display: block;
  width: 100%;
  padding: 1px 0;
  font-size: 11px;
  color: #000000;
}

/* Additional styles for PDF mode */
@media print {
  .input-container {
    padding-top: 1mm !important;
  }
  
  .input-text {
    position: absolute !important;
    top: 0 !important;
    left: 0 !important;
    color: #000000 !important;
    font-weight: normal !important;
    font-size: 30px !important;
  }
}

.pdf-text {
  font-size: 8px;
  line-height: 1.2;
  padding: 1px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

@media print {
  .pdf-text {
    font-size: 9px !important;
    line-height: 1.1 !important;
  }
}

.form-text {
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: block;
  padding-bottom: 2px;
}

@media print {
  .form-text {
    /* PDF-specific adjustments */
    bottom: 2px !important;
    line-height: 1.1 !important;
    font-family: Arial, sans-serif !important;
  }
  
  /* Ensure container has enough space */
  .border-b {
    min-height: 6mm !important;
  }
}

/* CSS Classes for PDF fields */
.pdf-line-container {
  position: relative;
  min-height: 20px;
  margin-top: 2px;
  padding-top: 2px;
}

.pdf-field-text {
  display: block;
  font-size: 11px;
  line-height: 1;
  padding-top: 2px;
  padding-bottom: 2px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-family: Arial, sans-serif;
}

/* Mobile-specific styles */
@media (max-width: 767px) {
  .form-container {
    padding: 0.1in;
    transform: scale(0.95);
    transform-origin: top center;
  }
  
  /* Ensure buttons are more visible on mobile */
  button {
    font-size: 14px;
    padding: 10px 16px !important;
  }
}
</style>
